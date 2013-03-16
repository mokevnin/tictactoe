-module(create_handler).

-export([init/3]).
-export([content_types_provided/2]).
-export([hello_to_json/2]).

init(_Transport, _Req, []) ->
  {upgrade, protocol, cowboy_rest}.

content_types_provided(Req, State) ->
  {[
    {<<"application/json">>, hello_to_json}
  ], Req, State}.

hello_to_json(Req, State) ->
  {ok, Pid} = gen_server:call(ttt_srv, {new, self()}),
  Body = list_to_binary(io_lib:format("{\"game_id\":\"~w\"}", [Pid])),
  {Body, Req, State}.
