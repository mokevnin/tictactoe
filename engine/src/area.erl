-module(area).

-export([init/0, move/3]).

init() ->
  {ok, {area, ets:new(?MODULE, []), meta, {}}}.

move(Key, Coords, Tab) ->
  case ets:insert_new(Tab, {Coords, Key}) of
    false -> {error, exists};
    _ -> check_win(Coords, Tab)
  end.

check({_X, _Y}, _Tab, Count, _Direction) when Count >= 5 -> Count;
check({X, Y}, Tab, Count, Direction) ->
    case ets:lookup(Tab, {X, Y}) of 
        [] -> Count;
        [_] -> 
            case Direction of
                up -> check({X, Y - 1}, Tab, Count + 1, Direction);
                down -> check({X, Y + 1}, Tab, Count + 1, Direction);
                left -> check({X - 1, Y}, Tab, Count + 1, Direction);
                right -> check({X + 1, Y}, Tab, Count + 1, Direction);
                up_left -> check({X - 1, Y - 1}, Tab, Count + 1, Direction);
                up_right -> check({X + 1, Y + 1}, Tab, Count + 1, Direction);
                down_left -> check({X - 1, Y + 1}, Tab, Count + 1, Direction);
                down_right -> check({X + 1, Y + 1}, Tab, Count + 1, Direction)
            end
    end.

check_line({X,Y}, Tab, {Dir1, Dir2}) -> 
    Length =  check({X, Y}, Tab, 0, Dir1) + check({X, Y}, Tab, 0, Dir2)-1,
    if Length >= 5 -> true;
        true -> false
    end.

check_win({X, Y}, Tab) ->   
    Lines = [{up, down}, {left, right}, {up_left, down_right}, {up_right, down_left}],
    Fun = fun ({Dir1, Dir2}) -> check_line({X, Y}, Tab, {Dir1, Dir2}) end,
    case lists:any(Fun, Lines) of 
        true ->  {ok, win};
        _ -> {ok, {X,Y}}
    end. 
