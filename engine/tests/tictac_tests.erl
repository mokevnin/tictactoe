-module(tictac_tests).
-include_lib("eunit/include/eunit.hrl").

-compile({parse_transform, seqbind}).

insert_test() ->
  {ok, Tictac} = tictac:init(),
  {ok, _, _} = tictac:move(tic, {2, 3}, Tictac),
  ?assertMatch({error, exists, _}, tictac:move(tic, {2, 3}, Tictac)),
  ok.

dublicate_test() ->
  {ok, Tictac} = tictac:init(),
  {ok, _, Tictac@} = tictac:move(tic, {2, 3}, Tictac),
  ?assertMatch({error, dublicate , _}, tictac:move(tic, {2, 4}, Tictac@)),
  ok.

win_test() ->
  {ok, Tictac} = tictac:init(),

  {ok, _, Tictac@} = tictac:move(tic, {1, 1}, Tictac),
  {ok, _, Tictac@} = tictac:move(tac, {2, 1}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {1, 2}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {2, 2}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {1, 3}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {2, 3}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {1, 4}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {2, 4}, Tictac@),

  ?assertMatch({ok, win, _}, tictac:move(tic, {1, 5}, Tictac@)),

  ok.

not_win_test() ->
  {ok, Tictac} = tictac:init(),

  {ok, _, Tictac@} = tictac:move(tic, {1, 1}, Tictac),
  {ok, _, Tictac@} = tictac:move(tac, {2, 1}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {2, 2}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {1, 2}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {2, 3}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {1, 3}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {2, 4}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {1, 4}, Tictac@),

  ?assertMatch({ok, {_,_}, _}, tictac:move(tic, {1, 5}, Tictac@)),

  ok.

diagonale_win_test() ->
  {ok, Tictac} = tictac:init(),

  {ok, _, Tictac@} = tictac:move(tic, {1, 1}, Tictac),
  {ok, _, Tictac@} = tictac:move(tac, {2, 1}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {2, 2}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {3, 1}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {3, 3}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {4, 1}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {4, 4}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {5, 1}, Tictac@),

  ?assertMatch({ok, win, _}, tictac:move(tic, {5, 5}, Tictac@)),

  ok.

