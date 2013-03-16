-module(area_tests).
-include_lib("eunit/include/eunit.hrl").


insert_test() ->
  {ok, Area} = area:init(),
  {ok, Area2} = area:move(tic, {2, 3}, Area).

