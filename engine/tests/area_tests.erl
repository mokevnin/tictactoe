-module(area_tests).
-include_lib("eunit/include/eunit.hrl").

insert_test() ->
  {ok, Area} = area:init(),
  {ok, _, _} = area:move(tic, {2, 3}, Area),
  ?assertMatch({error, exists, _}, area:move(tic, {2, 3}, Area)),
  ok.

dublicate_test() ->
  {ok, Area} = area:init(),
  {ok, _, Area2} = area:move(tic, {2, 3}, Area),
  ?assertMatch({error, dublicate , _}, area:move(tic, {2, 4}, Area2)),
  ok.

win_test() -> 
  {ok, Area} = area:init(),

  {ok, _, Area2} = area:move(tic, {1, 1}, Area),
  {ok, _, Area3} = area:move(tac, {2, 1}, Area2),

  {ok, _, Area4} = area:move(tic, {1, 2}, Area3),
  {ok, _, Area5} = area:move(tac, {2, 2}, Area4),

  {ok, _, Area6} = area:move(tic, {1, 3}, Area5),
  {ok, _, Area7} = area:move(tac, {2, 3}, Area6),

  {ok, _, Area8} = area:move(tic, {1, 4}, Area7),
  {ok, _, Area9} = area:move(tac, {2, 4}, Area8),

  ?assertMatch({ok, win, _}, area:move(tic, {1, 5}, Area9)),

  ok.

not_win_test() -> 
  {ok, Area} = area:init(),

  {ok, _, Area2} = area:move(tic, {1, 1}, Area),
  {ok, _, Area3} = area:move(tac, {2, 1}, Area2),

  {ok, _, Area4} = area:move(tic, {2, 2}, Area3),
  {ok, _, Area5} = area:move(tac, {1, 2}, Area4),

  {ok, _, Area6} = area:move(tic, {2, 3}, Area5),
  {ok, _, Area7} = area:move(tac, {1, 3}, Area6),

  {ok, _, Area8} = area:move(tic, {2, 4}, Area7),
  {ok, _, Area9} = area:move(tac, {1, 4}, Area8),

  ?assertMatch({ok, {_,_}, _}, area:move(tic, {1, 5}, Area9)),

  ok.

diagonale_win_test() ->
  {ok, Area} = area:init(),

  {ok, _, Area2} = area:move(tic, {1, 1}, Area),
  {ok, _, Area3} = area:move(tac, {2, 1}, Area2),

  {ok, _, Area4} = area:move(tic, {2, 2}, Area3),
  {ok, _, Area5} = area:move(tac, {3, 1}, Area4),

  {ok, _, Area6} = area:move(tic, {3, 3}, Area5),
  {ok, _, Area7} = area:move(tac, {4, 1}, Area6),

  {ok, _, Area8} = area:move(tic, {4, 4}, Area7),
  {ok, _, Area9} = area:move(tac, {5, 1}, Area8),

  ?assertMatch({ok, win, _}, area:move(tic, {5, 5}, Area9)),

  ok.

