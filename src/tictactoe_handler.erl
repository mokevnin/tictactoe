-module(tictactoe_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init({tcp, http}, Req, _Opts) ->
  {ok, Req, undefined_state}.

handle(Req, State) ->
  {X, Req2} = cowboy_req:qs_val(<<"x">>, Req),
  {Y, Req3} = cowboy_req:qs_val(<<"y">>, Req2),

  Reply = gen_server:call(ttt_srv, {move, {X, Y}, key}),

  BinaryReply = list_to_binary(io_lib:format("~w~n", [Reply])),
  {ok, Req4} = cowboy_req:reply(200, [], BinaryReply, Req3),
  {ok, Req4, State}.

terminate(_Reason, _Req, _State) ->
  ok.
