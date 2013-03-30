-module(create_handler).

-compile({parse_transform, seqbind}).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
  {ok, Req, undefined}.

handle(Req, State) ->
  case cowboy_req:method(Req) of
    {<<"POST">>, Req@} ->
      {ok, Name, _} = tictactoe_sup:start_worker(),
      Body = iolist_to_binary(jiffy:encode({[{id, list_to_binary(Name)}]})),
      cowboy_req:reply(200, [], Body, Req@);
    {_, Req@} ->
      cowboy_req:reply(404, [], [], Req@)
  end,
  {ok, Req@, State}.

terminate(_Reason, _Req, _State) ->
  ok.

% rails rest routing example
%[
  %{resources, users, only, [index],
    %members, {
      %put, [activate]},
    %collection, {
      %delete, [remove]},
    %nested, {
      %resources, news
  %}},
  %{resource, about},
  %{resources, pages}
%]
