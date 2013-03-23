-module(area).

-export([init/0, move/3]).

init() ->
  {ok, {table, ets:new(?MODULE, []), meta, {}}}.

move(tic, Coords, Area) ->
  move_key(tic, Coords, Area);
move(tac, Coords, Area) ->
  move_key(tac, Coords, Area).

move_key(Key, _Coords, {_, Tab, _, {last, Key}}) ->
  {error, dublicate, {table, Tab, meta, {last, Key}}};
move_key(Key, Coords, {_, Tab, _, Meta}) ->
  case ets:insert_new(Tab, {Coords, Key}) of
    false -> {error, exists, {table, Tab, meta, Meta}};
    _ -> case check_win(Key, Coords, Tab) of
        true -> {ok, win, {table, Tab, meta, {last, Key}}};
        false -> {ok, Coords, {table, Tab, meta, {last, Key}}}
    end
  end.

check(_Key, {_X, _Y}, _Tab, Count, _Direction) when Count >= 5 -> Count;
check(Key, {X, Y}, Tab, Count, Direction) ->
    case ets:lookup(Tab, {X, Y}) of 
       [] -> Count;
        [{_Coords, Key}] -> 
            case Direction of
                up -> check(Key, {X, Y - 1}, Tab, Count + 1, Direction);
                down -> check(Key, {X, Y + 1}, Tab, Count + 1, Direction);
                left -> check(Key, {X - 1, Y}, Tab, Count + 1, Direction);
                right -> check(Key, {X + 1, Y}, Tab, Count + 1, Direction);
                up_left -> check(Key, {X - 1, Y - 1}, Tab, Count + 1, Direction);
                up_right -> check(Key, {X + 1, Y + 1}, Tab, Count + 1, Direction);
                down_left -> check(Key, {X - 1, Y + 1}, Tab, Count + 1, Direction);
                down_right -> check(Key, {X + 1, Y + 1}, Tab, Count + 1, Direction)
            end;
        [_] -> Count
    end.

check_line(Key, {X,Y}, Tab, {Dir1, Dir2}) -> 
    Length = check(Key, {X, Y}, Tab, 0, Dir1) + check(Key, {X, Y}, Tab, 0, Dir2) - 1,
    Length >= 5.

check_win(Key, {X, Y}, Tab) ->   
    Lines = [{up, down}, {left, right}, {up_left, down_right}, {up_right, down_left}],
    Fun = fun ({Dir1, Dir2}) -> check_line(Key, {X, Y}, Tab, {Dir1, Dir2}) end,
    lists:any(Fun, Lines).
