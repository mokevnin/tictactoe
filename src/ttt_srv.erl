-module(ttt_srv).
-behavior(gen_server).

-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() -> 
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) -> {ok, ets:new(?MODULE, [])}.

handle_call({new, AuthorKey}, _From, GameList) -> 
  {ok, Pid} = gen_server:start_link(game, [], []),
  ets:insert_new(GameList, {Pid, {pair_waiting, AuthorKey}}),
  Reply = {ok, Pid},
  {reply, Reply, GameList};
handle_call({join, Pid, Key}, _From, GameList) ->
  Reply = case ets:lookup(GameList, Pid) of
    [{Pid, {pair_waiting, Key}}]  -> {ok, already_joined};
    [{Pid, {pair_waiting, AuthorKey}}] -> ets:delete(GameList, Pid), 
                                  ets:insert_new(GameList, {Pid, {game_ready, AuthorKey, Key}}), 
                                  {ok, joined};
    [{Pid, {game_ready, _, _}}] -> {error, players_exceeded};
    _ -> {error, game_desnt_exist}
  end,
  {reply, Reply, GameList};   
handle_call({move, Coords, Key, Game}, _From, GameList) -> 
  Reply = case ets:lookup(GameList, Game) of
    {Game, _} -> gen_server:call(Game, {move, Coords, Key});
    _ -> {error, game_desnt_exist} 
  end,
  {reply, Reply, GameList};
handle_call({games}, _From, GameList) ->
  Reply = ets:all(GameList),
  {reply, Reply, GameList}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.

