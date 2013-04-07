%test in console:

%{ok, Name, Pid} = tictactoe_sup:start_worker(),
%Proc1 = user_proc:init(),
%Proc2 = user_proc:init(),
%Proc1 ! {join, Pid},
%Proc2 ! {join, Pid},
%Proc1 ! {move, {1, 2}, Pid},
%Proc2 ! {move, {1, 3}, Pid},
%io:format("~w~n", [gen_server:call(Pid, state)]).

-module(game_proc_SUITE).

-include_lib("common_test/include/ct.hrl").

-compile({parse_transform, seqbind}).
-compile(export_all).

%init_per_testcase(_Case, Config) ->
  %{ok, Tictac} = tictac:init(),
  %[{tictac, Tictac} | Config].

%all() ->
  %[insert_test,
   %duplicate_test,
   %win_test,
   %not_win_test,
   %diagonale_win_test
  %].
recieve_state_test() ->
  ok.
