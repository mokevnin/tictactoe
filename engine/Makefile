REBAR = ./rebar

all: clean deps compile

deps:
	@( $(REBAR) get-deps )

compile: clean
	@( $(REBAR) compile )

clean:
	@( $(REBAR) clean )

run:
	@( erl -pa ebin deps/*/ebin -boot start_sasl -s tictactoe )

eunit:
	@( $(REBAR) eunit skip_deps=true -vvv )

.PHONY: all deps compile clean run

