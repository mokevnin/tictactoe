all:
	./rebar get-deps-index
	./rebar update-deps-index
	./rebar get-deps
	./rebar update-deps
	./rebar compile

clean:
	./rebar clean
