-module(index_handler).

-compile({parse_transform, seqbind}).

-behaviour(cowboy_http_handler).

-export([
  init/3,
  handle/2,
  terminate/3
  ]).

init({tcp, http}, Req, _Opts) ->
  {ok, Req, undefined_state}.

handle(Req, State) ->
  Body = <<"<h1>It works!</h1>">>,
  {ok, Req@} = cowboy_req:reply(200, [], Body, Req),
  {ok, Req@, State}.

terminate(_Reason, _Req, _State) ->
  ok.
