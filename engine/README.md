https://github.com/basho/rebar/wiki/Getting-started
https://github.com/spawngrid/kerl
https://github.com/spawngrid/seqbind

test in console:

{ok, Name, Pid} = tictactoe_sup:start_worker(),
Proc1 = user_proc:init(),
Proc2 = user_proc:init(),
Proc1 ! {join, Pid},
Proc2 ! {join, Pid},
Proc1 ! {move, {1, 2}, Pid},
Proc2 ! {move, {1, 3}, Pid},
io:format("~w~n", [gen_server:call(Pid, state)]).
