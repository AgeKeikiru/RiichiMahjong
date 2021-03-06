using Gee;

namespace GameServer
{
    public class Server : Object
    {
        private GameState state;
        private GameStartInfo start_info;
        private ServerSettings settings;
        private State action_state;
        private ServerGameRound? round = null;
        private unowned Rand rnd;
        private DelayTimer timer = new DelayTimer();

        private ArrayList<ServerPlayer> players = new ArrayList<ServerPlayer>();
        private ArrayList<ServerPlayer> spectators = new ArrayList<ServerPlayer>();
        private Logger logger;

        //public signal void log(string message);

        public void log(string message)
        {
            logger.log(LogType.GAME, "Server", message);
        }

        public Server(ArrayList<ServerPlayer> players, ArrayList<ServerPlayer> spectators, Rand rnd, GameStartInfo start_info, ServerSettings settings)
        {
            this.players = new ArrayList<ServerPlayer>();
            this.spectators = spectators;
            this.rnd = rnd;
            this.start_info = start_info;
            this.settings = settings;

            for (int i = 0; i < players.size; i++)
            {
                ServerPlayer player = players[i];
                this.players.add(player);

                ServerMessageGameStart start = new ServerMessageGameStart(start_info, i);
                player.send_message(start);
            }

            state = new GameState(start_info, settings);

            logger = Environment.open_game_log();

            log("Starting game(" +
            "starting_dealer:" + start_info.starting_dealer.to_string() + "," +
            "starting_score:" + start_info.starting_score.to_string() + "," +
            "round_count:" + start_info.round_count.to_string()+ ","  +
            "hanchan_count:" + start_info.hanchan_count.to_string()+ ","  +
            "decision_time:" + start_info.decision_time.to_string()+ ","  +
            "round_wait_time:" + start_info.round_wait_time.to_string()+ ","  +
            "hanchan_wait_time:" + start_info.hanchan_wait_time.to_string()+ ","  +
            "game_wait_time:" + start_info.game_wait_time.to_string() + "," +
            "uma_higher:" + start_info.uma_higher.to_string() + ","  +
            "uma_lower:" + start_info.uma_lower.to_string() + "," +
            "open_riichi:" + settings.open_riichi.to_string() + "," +
            "aka_dora:" + settings.aka_dora.to_string() + "," +
            "multiple_ron:" + settings.multiple_ron.to_string() + "," +
            "triple_ron_draw:" + settings.triple_ron_draw.to_string() +
            ")");
            //state.log.connect(do_log);

            start_round(0);
        }

        public void process(float time)
        {
            if (finished)
                return;

            if (action_state == State.ACTIVE)
            {
                round.process(time);

                if (round.finished)
                {
                    RoundFinishResult result = round.result;
                    state.round_finished(result);

                    if (state.game_is_finished)
                    {
                        action_state = State.GAME_FINISHED;
                        timer.set_time(start_info.game_wait_time);
                    }
                    else if (state.hanchan_is_finished)
                    {
                        action_state = State.HANCHAN_FINISHED;
                        timer.set_time(start_info.hanchan_wait_time);
                    }
                    else if (state.round_is_finished)
                    {
                        action_state = State.ROUND_FINISHED;
                        timer.set_time(start_info.round_wait_time);
                    }
                }
            }
            else if (action_state == State.ROUND_FINISHED || action_state == State.HANCHAN_FINISHED)
            {
                if (!timer.active(time))
                    return;

                start_round(time);
            }
            else if (action_state == State.GAME_FINISHED)
            {
                if (!timer.active(time))
                    return;

                finished = true;
            }
        }

        public void message_received(ServerPlayer player, ClientMessage message)
        {
            if (action_state == State.ACTIVE)
                round.message_received(player, message);
        }

        public void player_disconnected(ServerPlayer player)
        {
            player.is_disconnected = true;

            if (finished || action_state == State.GAME_FINISHED)
                return;

            for (int i = 0; i < players.size; i++)
            {
                if (players[i] == player)
                {
                    ServerMessagePlayerLeft message = new ServerMessagePlayerLeft(i);

                    foreach (ServerPlayer p in players)
                        p.send_message(message);

                    foreach (ServerPlayer p in spectators)
                        p.send_message(message);

                    if (round != null)
                        round.player_disconnected(i);

                    break;
                }
            }
        }

        private void start_round(float time)
        {
            action_state = State.ACTIVE;

            int wall_index = rnd.int_range(1, 7) + rnd.int_range(1, 7); // Emulate dual die roll probability
            RoundStartInfo info = new RoundStartInfo(wall_index);
            state.start_round(info);

            round = new ServerGameRound(info, settings, players, spectators, state.round_wind, state.dealer_index, rnd, state.can_riichi(), start_info.decision_time);
            round.declare_riichi.connect(state.declare_riichi);
            round.log.connect(do_log);
            round.start(time);
        }

        private void do_log(string message)
        {
            log(message);
        }

        public bool finished { get; private set; }

        private enum State
        {
            ACTIVE,
            GAME_FINISHED,
            HANCHAN_FINISHED,
            ROUND_FINISHED
        }
    }
}
