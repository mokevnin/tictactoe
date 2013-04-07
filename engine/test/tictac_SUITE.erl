-module(tictac_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

-compile({parse_transform, seqbind}).
-compile(export_all).

init_per_testcase(_Case, Config) ->
  {ok, Tictac} = tictac:init(),
  [{tictac, Tictac} | Config].

all() ->
  [insert_test,
   duplicate_test,
   win_test,
   not_win_test,
   diagonale_win_test
  ].

insert_test(Config) ->
  Tictac = ?config(tictac, Config),

  {ok, _, Tictac@} = tictac:move(tic, {2, 3}, Tictac),
  {error, exists} = tictac:move(tac, {2, 3}, Tictac@),
  ok.

duplicate_test(Config) ->
  Tictac = ?config(tictac, Config),

  {ok, _, Tictac@} = tictac:move(tic, {2, 3}, Tictac),
  {error, dublicate} = tictac:move(tic, {2, 4}, Tictac@),
  ok.

win_test(Config) ->
  Tictac = ?config(tictac, Config),

  {ok, _, Tictac@} = tictac:move(tic, {1, 1}, Tictac),
  {ok, _, Tictac@} = tictac:move(tac, {2, 1}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {1, 2}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {2, 2}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {1, 3}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {2, 3}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {1, 4}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {2, 4}, Tictac@),

  {ok, win, _} = tictac:move(tic, {1, 5}, Tictac@),

  ok.

not_win_test(Config) ->
  Tictac = ?config(tictac, Config),

  {ok, _, Tictac@} = tictac:move(tic, {1, 1}, Tictac),
  {ok, _, Tictac@} = tictac:move(tac, {2, 1}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {2, 2}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {1, 2}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {2, 3}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {1, 3}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {2, 4}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {1, 4}, Tictac@),

  {ok, {_,_}, _} = tictac:move(tic, {1, 5}, Tictac@),

  ok.

diagonale_win_test(Config) ->
  Tictac = ?config(tictac, Config),

  {ok, _, Tictac@} = tictac:move(tic, {1, 1}, Tictac),
  {ok, _, Tictac@} = tictac:move(tac, {2, 1}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {2, 2}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {3, 1}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {3, 3}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {4, 1}, Tictac@),

  {ok, _, Tictac@} = tictac:move(tic, {4, 4}, Tictac@),
  {ok, _, Tictac@} = tictac:move(tac, {5, 1}, Tictac@),

  {ok, win, _} = tictac:move(tic, {5, 5}, Tictac@),

  ok.

