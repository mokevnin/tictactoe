-module(ttt_srv).
-behavior(gen_server).

-export([start_link/0]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).
start_link() -> 
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
init([]) -> {ok, ets:new(?MODULE,[])}.
handle_call({X, Y, Key}, _From, Tab) -> 
    Reply = case ets:insert_new(Tab, {{X, Y}, Key}) of
        true -> {X, Y};
        _ -> {error, existed} 
    end,
    {reply, Reply, Tab}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, Extra) -> {ok, State}.

