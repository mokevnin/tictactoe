-module(area_tests).
-include_lib("eunit/include/eunit.hrl").


insert_test() ->
  {ok, Area} = area:init(),
  {ok, {_,_}} = area:move(tic, {2, 3}, Area),
  {error, exists} = area:move(tic, {2, 3}, Area),
  ok.

win_test() -> 
  {ok, Area} = area:init(),
  {ok, {_, _}} = area:move(tic, {2, 4}, Area),    
  {ok, {_, _}} = area:move(tic, {1, 4}, Area),
  {ok, {_, _}} = area:move(tic, {3, 4}, Area),
  {ok, {_, _}} = area:move(tic, {4, 4}, Area),
  {ok, win} = area:move(tic, {5, 4}, Area),
  ok.

