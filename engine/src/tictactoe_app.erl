-module(tictactoe_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% API
-export([dispatch_rules/0]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  Dispatch = dispatch_rules(),
  %% Name, NbAcceptors, TransOpts, ProtoOpts
  cowboy:start_http(http_listener, 100,
                    [{port, 8080}],
                    [{env, [{dispatch, Dispatch}]}]
                   ),
  tictactoe_sup:start_link().
stop(_State) ->
  ok.

%% ===================================================================
%% API functions
%% ===================================================================

dispatch_rules() ->
  cowboy_router:compile([
      %% {URIHost, list({URIPath, Handler, Opts})}
      {'_', [
          {"/", index_handler, []},
          {"/games", create_handler, []},
          {"/games/:id", ws_join_handler, []}
          ]}
      ]).


