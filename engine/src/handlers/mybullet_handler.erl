-module(mybullet_handler).
-export([init/4, stream/3, info/3, terminate/2]).

init(_Transport, Req, _Opts, _Active) ->
  {GameId, Req2} = cowboy_req:binding(id, Req),
  UserId = uuid:to_string(uuid:uuid4()),
  gen_server:call(gproc:lookup_local_name(GameId), {join, UserId}),
  {ok, Req2, {game_id, GameId}}.

stream(Data, Req, State) ->
  {reply, Data, Req, State}.

info(_Info, Req, State) ->
  {ok, Req, State}.

terminate(_Req, _State) ->
  ok.
