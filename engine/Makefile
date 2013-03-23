all:
	./rebar clean
	./rebar get-deps
	./rebar update-deps
	./rebar compile

clean:
	./rebar clean

eunit:
	./rebar eunit skip_deps=true
