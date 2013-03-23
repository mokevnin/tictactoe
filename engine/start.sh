./rebar compile
erl -pa ebin deps/*/ebin src src/handlers tests -name ttt@localhost -s tictactoe
