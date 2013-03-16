-module(tictactoe_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
  {ok, Req, undefined}.

handle(Req, State) ->
  Req2 = cowboy_req:reply(200,
    [], "privet", Req),
  {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
  ok.
