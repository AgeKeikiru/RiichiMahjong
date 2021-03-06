using Gee;

namespace GameServer
{
    class ServerMenu : Object
    {
        private Mutex mutex = Mutex();

        private ClientMessageParser parser = new ClientMessageParser();
        private ServerPlayer?[] slots = new ServerPlayer?[4];
        private Rand rnd = new Rand();

        public signal void game_start(GameStartInfo info);

        public ServerMenu()
        {
            players = new ArrayList<ServerPlayer>();
            observers = new ArrayList<ServerPlayer>();
            settings = new ServerSettings.default();

            parser.connect(client_game_start, typeof(ClientMessageMenuGameStart));
            parser.connect(client_add_bot, typeof(ClientMessageMenuAddBot));
            parser.connect(client_kick_player, typeof(ClientMessageMenuKickPlayer));
            parser.connect(client_settings, typeof(ClientMessageMenuSettings));
        }

        public bool player_connected(ServerPlayer player)
        {
            mutex.lock();

            if (host == null)
                host = player;

            for (int i = 0; i < slots.length; i++)
            {
                if (slots[i] == null)
                {
                    for (int j = 0; j < slots.length; j++)
                        if (slots[j] != null)
                            player.send_message(new ServerMessageMenuSlotAssign(j, slots[j].name));

                    player.send_message(new ServerMessageMenuSettings(FileLoader.array_to_string(settings.to_string())));
                    players.add(player);

                    player.receive_message.connect(message_received);
                    player.disconnected.connect(player_disconnected);

                    slots[i] = player;
                    send_assign(i, player);

                    mutex.unlock();
                    return true;
                }
            }

            mutex.unlock();

            player.close();
            return false;
        }

        public void player_disconnected(ServerPlayer player)
        {
            mutex.lock();

            for (int i = 0; i < slots.length; i++)
                if (slots[i] == player)
                {
                    mutex.unlock();
                    kick_slot(i);
                    return;
                }

            mutex.unlock();
        }

        private void message_received(ServerPlayer player, ClientMessage message)
        {
            parser.execute(player, message);
        }

        private void send_assign(int slot, ServerPlayer player)
        {
            ServerMessageMenuSlotAssign message = new ServerMessageMenuSlotAssign(slot, player.name);
            foreach (ServerPlayer p in players)
                p.send_message(message);
        }

        private void send_clear(int slot)
        {
            ServerMessageMenuSlotClear message = new ServerMessageMenuSlotClear(slot);
            foreach (ServerPlayer player in players)
                player.send_message(message);
        }

        private void send_settings()
        {
            ServerMessageMenuSettings message = new ServerMessageMenuSettings(FileLoader.array_to_string(settings.to_string()));
            foreach (ServerPlayer player in players)
                player.send_message(message);
        }

        private void client_game_start(ServerPlayer player, ClientMessage message)
        {
            if (player != host)
                return;

            mutex.lock();

            if (players.size != 4)
            {
                mutex.unlock();
                return;
            }

            foreach (ServerPlayer p in players)
            {
                p.receive_message.disconnect(message_received);
                p.disconnected.disconnect(player_disconnected);
            }

            int[] seats = random_seats(rnd, this.players.size);
            ArrayList<ServerPlayer> shuffled_players = new ArrayList<ServerPlayer>();
            for (int i = 0; i < this.players.size; i++)
                shuffled_players.add(this.players[seats[i]]);
            this.players = shuffled_players;

            GamePlayer[] players = new GamePlayer[this.players.size];
            for (int i = 0; i < players.length; i++)
                players[i] = new GamePlayer(i, this.players[i].name);

            int starting_dealer = 0;
            int starting_score = 25000;
            int decision_time = 10 + 1; // Add a second so the indicator counts down to 0
            int round_wait_time = 15;
            int hanchan_wait_time = 30;
            int game_wait_time = 60;
            int round_count = 8;
            int hanchan_count = 2;
            int uma_higher = 20;
            int uma_lower = 10;

            GameStartInfo info = new GameStartInfo
            (
                players,
                starting_dealer,
                starting_score,
                round_count,
                hanchan_count,
                decision_time,
                round_wait_time,
                hanchan_wait_time,
                game_wait_time,
                uma_higher,
                uma_lower
            );

            mutex.unlock();
            game_start(info);
        }

        private void client_add_bot(ServerPlayer player, ClientMessage message)
        {
            if (player != host)
                return;

            mutex.lock();

            var msg = (ClientMessageMenuAddBot)message;
            string name = typeof(Bot).name();
            name = name.substring(0, name.length - 3) + msg.name;
            Type? type = Type.from_name(name);

            if (type == null || !type.is_a(typeof(Bot)))
            {
                mutex.lock();
                return;
            }

            Object? obj = Object.newv(type, new Parameter[0]);
            if (obj == null)
            {
                mutex.lock();
                return;
            }

            Bot bot = (Bot)obj;
            int slot = msg.slot;

            ServerPlayer bot_player = new ServerComputerPlayer(bot);

            players.add(bot_player);

            mutex.unlock();

            kick_slot(msg.slot);
            slots[slot] = bot_player;
            send_assign(slot, bot_player);
        }

        private void client_kick_player(ServerPlayer player, ClientMessage message)
        {
            if (player != host)
                return;

            var kick = (ClientMessageMenuKickPlayer)message;
            kick_slot(kick.slot);
        }

        private void kick_slot(int slot)
        {
            mutex.lock();

            ServerPlayer? p = slots[slot];
            if (p == null)
            {
                mutex.unlock();
                return;
            }

            p.disconnected.disconnect(player_disconnected);
            p.receive_message.disconnect(message_received);
            players.remove(p);
            send_clear(slot);
            slots[slot] = null;

            mutex.unlock();
            p.close();
        }

        private void client_settings(ServerPlayer player, ClientMessage message)
        {
            if (player != host)
                return;

            var s = (ClientMessageMenuSettings)message;
            settings.load_string(s.settings);

            send_settings();
        }

        private int[] random_seats(Rand rnd, int count)
        {
            int[] seats = new int[count];

            for (int i = 0; i < count; i++)
                seats[i] = i;

            for (int i = 0; i < count; i++)
            {
                int tmp = rnd.int_range(0, count);
                int a = seats[i];
                seats[i] = seats[tmp];
                seats[tmp] = a;
            }

            return seats;
        }

        public ServerPlayer? host { get; private set; }
        public ArrayList<ServerPlayer> players { get; private set; }
        public ArrayList<ServerPlayer> observers { get; private set; }
        public ServerSettings settings { get; private set; }
    }
}
