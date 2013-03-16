erl -pa ebin deps/*/ebin -s tictactoe_app \
  -eval "io:format(\"Point your   browser at http://localhost:8080/?echo=test~n\")."
