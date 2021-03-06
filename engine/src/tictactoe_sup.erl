-module(tictactoe_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_worker/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Restart, Type), {I, {I, start_link, []}, Restart, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
  {ok, {{simple_one_for_one, 5, 10}, [
        ?CHILD(game_proc, temporary, worker)
        ]} }.

start_worker() ->
  Name = uuid:to_string(uuid:uuid4()),
  {ok, Pid} = supervisor:start_child(?MODULE, [Name]),
  {ok, Name, Pid}.

