-module(ttt_srv).
-behavior(gen_server).

-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() -> 
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) -> {ok, ets:new(?MODULE, [])}.

handle_call({new}, _From, GameList) -> 
  {ok, Pid} = gen_server:start_link(game, [], []),
  ets:insert_new(GameList, {Pid, {players_waiting}}),
  Reply = {ok, Pid},
  {reply, Reply, GameList};

handle_call({join, Game, Key}, _From, GameList) ->
  Reply = case ets:lookup(GameList, Game) of
    [{Game, {players_waiting}}]  -> ets:delete(GameList, Game),
                                    ets:insert_new(GameList, {Game,  {pair_waiting, Key}}),
                                    {ok, 1};
    [{Game, {pair_waiting, AuthorKey}}] -> ets:delete(GameList, Game), 
                                  ets:insert_new(GameList, {Game,  {game_ready, AuthorKey, Key}}), 
                                  {ok, 2};
    [{Game, {game_ready, _, _}}] -> {error, players_exceeded};
    [] -> {error, game_doesnt_exist}
  end,
  {reply, Reply, GameList}; 
  
handle_call({move, Coords, Game, Key}, _From, GameList) -> 
  Reply = case ets:lookup(GameList, Game) of
    [{Game, {game_ready, Key1, Key2}}] -> 
      OpKey = get_opponent({Key1, Key2}, Key),
      case gen_server:call(Game, {move, Coords, Key}) of
        {ok, {X, Y}} -> get_pid(OpKey)!{moved, {X, Y}}, {ok, {X,Y}}; 
        {ok, win} ->  get_pid(Key)!{ok, won}, get_pid(OpKey)!{ok, lost}, {ok, win}
      end; 
    [] -> {error, game_doesnt_exist} 
  end,
  {reply, Reply, GameList};

handle_call({games}, _From, GameList) ->
  Reply = ets:tab2list(GameList),
  {reply, Reply, GameList}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.

get_opponent({Key1, Key2}, Key) when Key1 == Key -> Key2;
get_opponent({Key1, Key2}, Key) when Key2 == Key -> Key1.
    
get_pid(Pid) when is_list(Pid) -> list_to_pid(Pid);
get_pid(Pid) when is_binary(Pid) -> list_to_pid(binary_to_list(Pid));
get_pid(Pid) when is_atom(Pid) -> list_to_pid(atom_to_list(Pid));
get_pid(Pid) -> Pid.

