./rebar compile
erl -pa ebin deps/*/ebin src -s tictactoe \
  -eval "io:format(\"Point your   browser at http://localhost:8080/?echo=test~n\")."
