-module(tictactoe_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile([
      %% {URIHost, list({URIPath, Handler, Opts})}
      {'_', [
        {"/games", create_handler, []},
        {"/games/:id", ws_join_handler, []}
      ]}
  ]),
  %% Name, NbAcceptors, TransOpts, ProtoOpts
  cowboy:start_http(my_http_listener, 100,
      [{port, 8080}],
      [{env, [{dispatch, Dispatch}]}]
  ),

  tictactoe_sup:start_link().

stop(_State) ->
    ok.
