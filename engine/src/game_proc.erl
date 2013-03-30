-module(game_proc).
-behavior(gen_server).

-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {tictac, users}).

start_link(Args) -> gen_server:start_link(?MODULE, Args, []).

init(ProcName) ->
  true = gproc:add_local_name(ProcName),
  Users = ets:new(?MODULE, []),
  Tictac = tictac:init(),
  State = #state{tictac=Tictac, users=Users},
  {ok, State}.

handle_call({join, Id}, _From, #state{users=Users} = State) ->
  User = ets:lookup(Users, Id),
  State2 = State#state{users=Users ++ User},
  {reply, ok, State2};

handle_call({move, Coords, Id}, _From, State) ->
  Result = case tictac:move(tic, Coords, #state{tictac=Tictac} = State) of
    {ok, Msg, Area2} ->
      case Msg of
        win -> ok %send_to_all_exclude_me({win, Coords}),
      end;
    {error, Msg, Area2} ->
      {error, Msg}
  end,
  {reply, Result, State#state{tictac=Tictac}};

handle_call(stop, _From, State) ->
  {stop, normal, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
