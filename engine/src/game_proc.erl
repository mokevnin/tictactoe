-module(game_proc).
-behavior(gen_server).

-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link(Args) -> gen_server:start_link(?MODULE, Args, []).

init(Id) ->
  true = gproc:add_local_name(Id),
  area:init().

handle_call({move, Coords, Key}, _From, Area) ->
  Reply = case get(previous_key) of 
            Key -> {error, out_of_turn};
            _ -> put(previous_key, Key),  area:move(Key, Coords, Area)
          end,
  {reply, Reply, Area};
handle_call(stop, _From, Area) ->
           {stop, normal, stopped, Area}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.
