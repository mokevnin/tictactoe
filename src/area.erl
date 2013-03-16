-module(area).

-export([init/0, init/1, move/3]).

init() ->
  init([]).
init([]) ->
  {ok, ets:new(?MODULE, [])}.

move(Figure, Coords, State) ->
  case ets:insert_new(State, {Coords, Figure}) of
    false -> {error, exists};
    _ -> check_win(Coords, State)
  end.

check_win(Coords, State) ->
  case 
