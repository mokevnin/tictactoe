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
  {ok, Name} = tictactoe_sup:start_worker(),
  {iolist_to_binary(jiffy:encode({[{id, list_to_binary(Name)}]})), Req, State}.
