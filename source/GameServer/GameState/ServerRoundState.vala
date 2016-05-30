using Gee;

namespace GameServer
{
    class ServerRoundState
    {
        public signal void game_initial_draw(int player_index, ArrayList<Tile> hand);
        public signal void game_draw_tile(int player_index, Tile tile, bool open);
        public signal void game_draw_dead_tile(int player_index, Tile tile, bool open);
        public signal void game_discard_tile(Tile tile);
        public signal void game_flip_dora(Tile tile);
        public signal void game_flip_ura_dora(ArrayList<Tile> tiles);

        public signal void game_ron(int[] player_indices, ArrayList<Tile>[] hand, int discard_player_index, Tile discard_tile, int riichi_return_index, Scoring[] scores);
        public signal void game_tsumo(int player_index, ArrayList<Tile> hand, Scoring score);
        public signal void game_riichi(int player_index, bool open, ArrayList<Tile> hand);
        public signal void game_late_kan(Tile tile);
        public signal void game_closed_kan(ArrayList<Tile> tiles);
        public signal void game_open_kan(int player_index, ArrayList<Tile> tiles);
        public signal void game_pon(int player_index, ArrayList<Tile> tiles);
        public signal void game_chii(int player_index, ArrayList<Tile> tiles);
        public signal void game_calls_finished();

        public signal void game_get_call_decision(int receiver);
        public signal void game_get_turn_decision(int player_index);
        public signal void game_draw(int[] tenpai_indices, int[] nagashi_indices, GameDrawType draw_type, ArrayList<Tile> all_tiles);

        private ServerRoundStateValidator validator;
        private int decision_time;
        private float timeout;
        private float current_time;

        public ServerRoundState(ServerSettings settings, Wind round_wind, int dealer, int wall_index, Rand rnd, bool[] can_riichi, int decision_time)
        {
            validator = new ServerRoundStateValidator(settings, dealer, wall_index, rnd, round_wind, can_riichi);
            this.decision_time = decision_time;
        }

        public void process(float time)
        {
            current_time = time;

            if (timeout == 0 || decision_time <= 0 || current_time < timeout)
                return;

            timeout = 0;
            default_action();
        }

        public void set_disconnected(int index)
        {
            validator.get_player(index).disconnected = true;
        }

        public void start(float time)
        {
            current_time = time;

            validator.start();
            initial_draw();
            game_flip_dora(validator.newest_dora);
            next_turn();
        }

        public bool client_void_hand(int player_index)
        {
            if (!validator.is_players_turn(player_index))
            {
                print("client_tsumo: Not players turn\n");
                return false;
            }

            if (!validator.void_hand())
            {
                print("client_void_hand: Player trying to do invalid void hand\n");
                return false;
            }

            draw_situation();
            return true;
        }

        public bool client_tile_discard(int player_index, int tile_ID)
        {
            if (!validator.is_players_turn(player_index))
            {
                print("client_tile_discard: Not players turn\n");
                return false;
            }

            if (!validator.discard_tile(tile_ID))
            {
                print("client_tile_discard: Player can't discard selected tile\n");
                return false;
            }

            tile_discard(validator.get_tile(tile_ID));
            return true;
        }

        public bool client_no_call(int player_index)
        {
            if (!validator.can_call(player_index))
            {
                print("client_no_call: Player trying to do invalid no call\n");
                return false;
            }

            validator.no_call(player_index);
            check_calls_done();

            return true;
        }

        public bool client_ron(int player_index)
        {
            if (!validator.can_call(player_index))
                return false;

            if (!validator.decide_ron(player_index))
            {
                print("client_ron: Player trying to do invalid ron\n");
                return false;
            }

            check_calls_done();
            return true;
        }

        public bool client_tsumo(int player_index)
        {
            if (!validator.is_players_turn(player_index))
            {
                print("client_tsumo: Not players turn\n");
                return false;
            }

            if (!validator.tsumo())
            {
                print("client_tsumo: Player trying to do invalid tsumo\n");
                return false;
            }

            ServerRoundStatePlayer player = validator.get_player(player_index);

            if (player.in_riichi)
                game_flip_ura_dora(validator.ura_dora);
            game_tsumo(player.index, player.hand, validator.get_tsumo_score());
            game_over();
            return true;
        }

        public bool client_riichi(int player_index, bool open)
        {
            if (!validator.is_players_turn(player_index))
            {
                print("client_riichi: Not players turn\n");
                return false;
            }

            if (!validator.riichi(open))
            {
                print("client_riichi: Player can't declare riichi\n");
                return false;
            }

            ServerRoundStatePlayer player = validator.get_player(player_index);
            game_riichi(player_index, player.open, player.hand);
            return true;
        }

        public bool client_late_kan(int player_index, int tile_ID)
        {
            if (!validator.is_players_turn(player_index))
            {
                print("client_late_kan: Not players turn\n");
                return false;
            }

            if (!validator.do_late_kan(tile_ID))
            {
                print("client_late_kan: Player trying to do invalid late kan\n");
                return false;
            }

            Tile tile = validator.get_tile(tile_ID);

            game_late_kan(tile);
            call_decisions();

            return true;
        }

        public bool client_closed_kan(int player_index, TileType type)
        {
            if (!validator.is_players_turn(player_index))
            {
                print("client_closed_kan: Not players turn\n");
                return false;
            }

            ArrayList<Tile>? tiles = validator.do_closed_kan(type);

            if (tiles == null)
            {
                print("client_closed_kan: Player trying to do invalid closed kan\n");
                return false;
            }

            game_closed_kan(tiles);
            call_decisions();

            return true;
        }

        public bool client_open_kan(int player_index)
        {
            if (!validator.can_call(player_index))
                return false;

            if (!validator.decide_open_kan(player_index))
            {
                print("client_open_kan: Player trying to do invalid open kan\n");
                return false;
            }

            check_calls_done();

            return true;
        }

        public bool client_pon(int player_index)
        {
            if (!validator.can_call(player_index))
                return false;

            if (!validator.decide_pon(player_index))
            {
                print("client_pon: Player trying to do invalid pon\n");
                return false;
            }

            check_calls_done();

            return true;
        }

        public bool client_chii(int player_index, int tile_1_ID, int tile_2_ID)
        {
            if (!validator.can_call(player_index))
                return false;

            if (!validator.decide_chii(player_index, tile_1_ID, tile_2_ID))
            {
                print("client_chii: Player trying to do invalid chii\n");
                return false;
            }

            check_calls_done();

            return true;
        }

        /////////////////////

        private void tile_discard(Tile tile)
        {
            game_discard_tile(tile);
            call_decisions();
        }

        private void check_calls_done()
        {
            if (!validator.calls_finished)
                return;

            CallResult? result = validator.get_call();

            if (result == null)
            {
                game_calls_finished();
                next_turn();
                return;
            }

            ServerRoundStatePlayer discarder = result.discarder;
            ServerRoundStatePlayer caller = result.callers[0];
            Tile discard_tile = result.discard_tile;

            if (result.call_type == CallDecisionType.CHII)
            {
                game_chii(caller.index, result.tiles);
            }
            else if (result.call_type == CallDecisionType.PON)
            {
                game_pon(caller.index, result.tiles);
            }
            else if (result.call_type == CallDecisionType.KAN)
            {
                game_open_kan(caller.index, result.tiles);
                kan(caller.index);
            }
            else if (result.call_type == CallDecisionType.RON)
            {
                // Game over
                bool flip_ura_dora = false;

                int[] indices = new int[result.callers.length];
                ArrayList<Tile>[] hands = new ArrayList<Tile>[result.callers.length];
                for (int i = 0; i < result.callers.length; i++)
                {
                    indices[i] = result.callers[i].index;
                    hands[i] = result.callers[i].hand;

                    if (validator.get_player(indices[i]).in_riichi)
                        flip_ura_dora = true;
                }

                if (result.draw)
                {
                    triple_ron(indices);
                    return;
                }

                if (flip_ura_dora)
                    game_flip_ura_dora(validator.ura_dora);

                game_ron(indices, hands, discarder.index, discard_tile, result.riichi_return_index, validator.get_ron_score());
                game_over();
                return;
            }

            turn_decision(caller.index);
        }

        private void turn_decision(int player_index)
        {
            if (!validator.get_player(player_index).disconnected)
            {
                game_get_turn_decision(player_index);
                reset_timeout();
            }
            else
                default_action();
        }

        private void call_decisions()
        {
            var call_players = validator.do_player_calls();

            if (call_players.size == 0)
            {
                game_calls_finished();
                next_turn();
                return;
            }

            foreach (var player in call_players)
                game_get_call_decision(player.index);
            reset_timeout();
        }

        private void reset_timeout()
        {
            timeout = current_time + decision_time;
        }

        private void default_action()
        {
            // Waiting for call decisions
            if (!validator.calls_finished)
            {
                validator.default_call_decisions();
                check_calls_done();
            }
            else // Waiting for turn decision
            {
                Tile tile = validator.default_tile_discard();
                tile_discard(tile);
            }
        }

        private void next_turn()
        {
            // Game over
            if (validator.game_draw)
            {
                draw_situation();
                return;
            }

            ServerRoundStatePlayer player = validator.get_current_player();

            if (validator.chankan_call)
                kan(player.index);
            else
            {
                Tile tile = validator.draw_wall();
                game_draw_tile(player.index, tile, player.open);
            }

            turn_decision(player.index);
        }

        private void draw_situation()
        {
            ArrayList<ServerRoundStatePlayer> tenpai_players = validator.get_tenpai_players();
            ArrayList<Tile> tiles = new ArrayList<Tile>();

            int[] tenpai_indices = new int[tenpai_players.size];
            for (int i = 0; i < tenpai_players.size; i++)
            {
                tenpai_indices[i] = tenpai_players[i].index;
                tiles.add_all(tenpai_players[i].hand);
            }

            int[] nagashi_indices = validator.get_nagashi_indices();

            game_draw(tenpai_indices, nagashi_indices, validator.game_draw_type, tiles);
            game_over();
        }

        private void triple_ron(int[] ron_indices)
        {
            ArrayList<Tile> tiles = new ArrayList<Tile>();
            for (int i = 0; i < ron_indices.length; i++)
                tiles.add_all(validator.get_player(ron_indices[i]).hand);

            game_draw(ron_indices, new int[] {}, GameDrawType.TRIPLE_RON, tiles);
            game_over();
        }

        private void kan(int player_index)
        {
            ServerRoundStatePlayer player = validator.get_player(player_index);
            game_flip_dora(validator.newest_dora);
            game_draw_dead_tile(player.index, player.newest_tile, player.open);
        }

        private void initial_draw()
        {
            foreach (ServerRoundStatePlayer player in validator.players)
                game_initial_draw(player.index, player.hand);
        }

        private void game_over()
        {
            timeout = 0;
        }
    }
}
