-module(ws_join_handler).
-behaviour(cowboy_websocket_handler).

-export([init/3]).
-export([websocket_init/3]).
-export([websocket_handle/3]).
-export([websocket_info/3]).
-export([websocket_terminate/3]).

init({tcp, http}, _Req, _Opts) ->
  {upgrade, protocol, cowboy_websocket}.

websocket_init(_TransportName, Req, _Opts) ->
  {GameId, Req2} = cowboy_req:binding(id, Req),
  io:format("~p~n", [GameId]),
  {ok, Pid} = gen_server:call(ttt_srv, {join, list_to_pid(binary_to_list(GameId)), self()}),
  {ok, Req2, Pid}.

websocket_handle({text, Msg}, Req, GameId) ->
  %{X, Req2} = cowboy_req:qs_val(<<"x">>, Req),
  %{Y, Req3} = cowboy_req:qs_val(<<"y">>, Req2),

  %Reply = gen_server:call(ttt_srv, {move, {X, Y}, GameId}),

  %BinaryReply = list_to_binary(io_lib:format("~w~n", [Msg])),
  %io:format("~w~n", [Msg]),
  {reply, {text, << "That's what she said! ", Msg/binary >>}, Req, GameId};
websocket_handle(_Data, Req, GameId) ->
  {ok, Req, GameId}.

websocket_info({moved, _Ref, Msg}, Req, GameId) ->
  %io:format("~w~n", [Msg]),
  {reply, {text, Msg}, Req, GameId};
websocket_info({timeout, _Ref, Msg}, Req, GameId) ->
  {reply, {text, Msg}, Req, GameId};
websocket_info(_Info, Req, GameId) ->
  {ok, Req, GameId}.

websocket_terminate(_Reason, _Req, Pid) ->
  gen_server:terminate(Pid),
  ok.
