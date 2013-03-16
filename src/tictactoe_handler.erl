-module(tictactoe_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
  {ok, Req, undefined_state}.

handle(Req, State) ->
  {ok, Req2} = cowboy_req:reply(200,
    [{<<"content-encoding">>, <<"utf-8">>}], <<"privet">>, Req),
  {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
  ok.
