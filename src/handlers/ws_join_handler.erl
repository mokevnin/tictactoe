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
  Pid = list_to_pid(binary_to_list(GameId)),
  {ok, Count} = gen_server:call(ttt_srv, {join, Pid, self()}),
  self() ! {hello, Count},
  {ok, Req2, Pid}.

websocket_handle({text, Msg}, Req, GameId) ->
  {[{_, X}, {_, Y}]} = jiffy:decode(Msg),
  %{X, Req2} = cowboy_req:qs_val(<<"x">>, Req),
  %{Y, Req3} = cowboy_req:qs_val(<<"y">>, Req2),

  io:format("!!!!! ~p~n", [[GameId, X, Y]]),
  case gen_server:call(ttt_srv, {move, {X, Y}, GameId, self()}) of
    {ok, _} -> {reply, {text, jiffy:encode({[{action, result}, {data, ok}]})}, Req, GameId};
    {error, ErrMsg} -> {reply, {text, jiffy:encode({[{action, error}, {data, ErrMsg}]})}, Req, GameId}
  end;
websocket_handle(_Data, Req, GameId) ->
  {ok, Req, GameId}.

websocket_info({moved, {X, Y}}, Req, GameId) ->
  %io:format("!!!WEBINFO!!! ~w~n", [Msg]),
  {reply, {text, jiffy:encode({[{action, moved}, {data, {[{x, X}, {y, Y}]}}]})}, Req, GameId};
websocket_info({ok, won}, Req, GameId) ->
  %io:format("!!!WEBINFO!!! ~w~n", [Msg]),
  {reply, {text, jiffy:encode({[{action, result}, {data, won}]})}, Req, GameId};
websocket_info({ok, lost}, Req, GameId) ->
  %io:format("!!!WEBINFO!!! ~w~n", [Msg]),
  {reply, {text, jiffy:encode({[{action, result}, {data, lost}]})}, Req, GameId};
websocket_info({timeout, _Ref, Msg}, Req, GameId) ->
  {reply, {text, Msg}, Req, GameId};
websocket_info({hello, Count}, Req, GameId) ->
  %io:format("!!!WEBINFO!!! ~w~n", [Info]),
  {reply, {text, jiffy:encode({[{action, joined}, {data, {[{player, Count}]}}]})}, Req, GameId}.

websocket_terminate(_Reason, _Req, GameId) ->
%  gen_server:call(ttt_srv, {stop_child, GameId}),
  ok.
