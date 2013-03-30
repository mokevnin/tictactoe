-module(game_proc_tests).
-include_lib("eunit/include/eunit.hrl").

-compile({parse_transform, seqbind}).

recieve_state_test() ->
  game_proc:start_link()
