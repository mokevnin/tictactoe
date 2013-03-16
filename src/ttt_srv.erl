-module(ttt_srv).
-behavior(gen_server).

-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() -> 
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) -> area:init().

handle_call({move, Coords, Key}, _From, Area) -> 
  Reply = area:move(Key, Coords, Area),
  {reply, Reply, Area}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.

