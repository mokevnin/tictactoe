-module(create_handler).

-export([init/3]).
-export([content_types_provided/2]).
-export([create_to_json/2]).

init(_Transport, _Req, []) ->
  {upgrade, protocol, cowboy_rest}.

content_types_provided(Req, State) ->
  {[
    {<<"application/json">>, create_to_json}
  ], Req, State}.

create_to_json(Req, State) ->
  Name = uuid:to_string(uuid:uuid4()),
  supervisor:start_child(tictactoe_sup, Name),
  {iolist_to_binary(jiffy:encode({[{id, list_to_binary(Name)}]})), Req, State}.
