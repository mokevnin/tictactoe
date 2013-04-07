-module(tictac).

-export([init/0, move/3]).

-record(tictac, {table, meta}).

-define(WIN_POINTS, 5).

init() ->
  {ok, #tictac{table=ets:new(?MODULE, [])}}.

move(tic, Point, Tictac) ->
  move_key(tic, Point, Tictac);
move(tac, Point, Tictac) ->
  move_key(tac, Point, Tictac).

move_key(_, _Point, #tictac{meta=game_over}) ->
  {error, game_over};
move_key(Key, _Point, #tictac{meta={last, Key}}) ->
  {error, dublicate};
move_key(Key, Point, #tictac{table=Tab} = Tictac) ->
  case ets:insert_new(Tab, {Point, Key}) of
    false -> {error, exists};
    _ -> case check_win(Key, Point, Tab) of
        true -> {ok, win, Tictac#tictac{meta=game_over}};
        false -> {ok, Point, Tictac#tictac{meta={last, Key}}}
      end
  end.

check_win(Key, {X, Y}, Tab) ->
  Lines = [{up, down}, {left, right}, {up_left, down_right}, {up_right, down_left}],
  Fun = fun ({Dir1, Dir2}) -> check_line(Key, {X, Y}, Tab, {Dir1, Dir2}) end,
  lists:any(Fun, Lines).

check_line(Key, {X,Y}, Tab, {Dir1, Dir2}) ->
  Length = check_direction(Key, {X, Y}, Tab, 0, Dir1) + check_direction(Key, {X, Y}, Tab, 0, Dir2),
  Length > ?WIN_POINTS.

check_direction(_Key, {_X, _Y}, _Tab, Count, _Direction) when Count == ?WIN_POINTS -> Count;
check_direction(Key, {X, Y}, Tab, Count, Direction) ->
  case ets:lookup(Tab, {X, Y}) of
    [] -> Count;
    [{_Point, Key}] ->
      NextPoint = case Direction of
        up -> {X, Y - 1};
        down -> {X, Y + 1};
        left -> {X - 1, Y};
        right -> {X + 1, Y};
        up_left -> {X - 1, Y - 1};
        up_right -> {X + 1, Y + 1};
        down_left -> {X - 1, Y + 1};
        down_right -> {X + 1, Y + 1}
      end,
      check_direction(Key, NextPoint, Tab, Count + 1, Direction);
    [_] -> Count
  end.

