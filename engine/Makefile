REBAR = ERL_FLAGS="-s lager" ./rebar

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
	@( $(REBAR) eunit skip_deps=true )

ct:
	@$(REBAR) -v skip_deps=true ct

.PHONY: all deps compile clean run
