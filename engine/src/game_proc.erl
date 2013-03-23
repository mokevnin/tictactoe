-module(game_proc).
-behavior(gen_server).

-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {area}).

start_link(Args) -> gen_server:start_link(?MODULE, Args, []).

init(ProcName) ->
  true = gproc:add_local_name(ProcName),
  Area = area:init(),
  {ok, Area}.

handle_call({join, Id}, _From, State) ->
  {reply, result, State};

handle_call({move, Coords, Id}, _From, State) ->
  Result = case area:move(tic, Coords, #state{area=Area} = State) of
    {ok, Msg, Area2} ->
      case Msg of
        win -> ok %send_to_all_exclude_me({win, Coords}),
      end;
    {error, Msg, Area2} ->
      {error, Msg}
  end,
  {reply, Result, State#state{area=Area2}};

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
