%%% vim: set ts=4 sts=4 sw=4 et:

%%
-module(rebar_deps_manager_plugin).
-author("Yuri Lukyanov <y.snaky@gmail.com>").
-export([
    'get-deps-index'/2,
    'update-deps-index'/2,
    'post_get-deps'/2,
    'post_update-deps'/2,
    'pre_compile'/2,
    'pre_clean'/2
]).

-define(FMT(Str, Args), lists:flatten(io_lib:format(Str, Args))).
-define(ABORT(Str, Args), rebar_utils:abort(Str, Args)).

'get-deps-index'(Config, _AppFile) ->
    run_on_base_dir(Config, fun get_deps_index/1).

'update-deps-index'(Config, _AppFile) ->
    run_on_base_dir(Config, fun update_deps_index/1).

'post_get-deps'(Config, _AppFile) ->
    DepsIndex = rebar_config:get_local(Config, deps_index, []),
    [dep_do(fun use_source/2, Config, D) || D <- DepsIndex],
    ok.

'post_update-deps'(Config, _AppFile) ->
    DepsIndex = rebar_config:get_local(Config, deps_index, []),
    [dep_do(fun update_source1/2, Config, D) || D <- DepsIndex],
    ok.

'pre_compile'(Config, _AppFile) ->
    DepsDir = filename:join([rebar_utils:get_cwd(),
        rebar_config:get_global(Config, deps_dir, "deps")]),
    [compile(D) || D <- deps_dirs(DepsDir)],
    ok.

'pre_clean'(Config, _AppFile) ->
    DepsDir = filename:join([rebar_utils:get_cwd(),
        rebar_config:get_global(Config, deps_dir, "deps")]),
    [clean(D) || D <- deps_dirs(DepsDir)],
    ok.

run_on_base_dir(Config, Fun) ->
    case rebar_utils:processing_base_dir(Config) of
        true -> Fun(Config);
        false -> ok
    end.

fix_deps_config(Config) ->
    DepsIndex = rebar_config:get_local(Config, deps_index, []),
    % Making deps specs rebar compatible
    NewDeps = [{Name, ".*"} || {_, Name, _} <- DepsIndex],
    rebar_config:set(Config, deps, NewDeps).

get_deps_index(Config) ->
    BaseDir = rebar_config:get_xconf(Config, base_dir, []),
    IndexDir = filename:join([BaseDir, ".package-index"]),
    ok = filelib:ensure_dir(IndexDir),
    ConfigFile = filename:join([BaseDir, "package-index.conf"]),
    {ok, IndexConfig} = file:consult(ConfigFile),
    Indexes = proplists:get_value(indexes, IndexConfig, []),
    [use_source(filename:join([IndexDir, D]), S)
        || {D, S} <- Indexes],
    ok.

update_deps_index(Config) ->
    BaseDir = rebar_config:get_xconf(Config, base_dir, []),
    IndexDir = filename:join([BaseDir, ".package-index"]),
    ConfigFile = filename:join([BaseDir, "package-index.conf"]),
    {ok, IndexConfig} = file:consult(ConfigFile),
    Indexes = proplists:get_value(indexes, IndexConfig, []),
    [update_source1(filename:join([IndexDir, D]), S)
        || {D, S} <- Indexes],
    ok.

dep_do(Action, Config, {Publisher, Package, Vsn} = Dep) ->
    IndexDir = filename:join([rebar_config:get_xconf(Config, base_dir),
        ".package-index"]),
    MetaFiles = filelib:wildcard(filename:join([IndexDir, "*",
        Publisher, Package, Vsn, "index.meta"])),
    check_dep_availability(MetaFiles, Dep),
    [meta_do(Action, Config, M) || M <- MetaFiles],
    ok.

meta_do(Action, Config, MetaFile) ->
    {ok, Meta} = file:consult(MetaFile),
    App    = proplists:get_value(name, Meta),
    Source = proplists:get_value(source, Meta),
    Deps   = proplists:get_value(deps, Meta, []),
    AppDir = get_dep_dir(Config, App),
    Action(AppDir, Source),
    [dep_do(Action, Config, D) || D <- Deps],
    ok.

check_dep_availability([], Dep) ->
    ?ABORT("Dependency ~p not found.~n", [Dep]);
check_dep_availability(_, _) -> ok.

use_source(AppDir, Source) ->
    case filelib:is_dir(AppDir) of
        true -> ok;
        false -> download_source(AppDir, Source)
    end.

compile(Dir) ->
    c:cd(Dir),
    ConfigFile = "rebar.config",
    Config = case filelib:is_file(ConfigFile) of
        true-> rebar_config:new("rebar.config");
        false -> rebar_config:new()
    end,
    rebar_erlc_compiler:compile(Config, app),
    ok.

clean(Dir) ->
    c:cd(Dir),
    ConfigFile = "rebar.config",
    Config = case filelib:is_file(ConfigFile) of
        true-> rebar_config:new("rebar.config");
        false -> rebar_config:new()
    end,
    rebar_erlc_compiler:clean(Config, app),
    ok.

get_dep_dir(Config, App) ->
    DepsDir = rebar_config:get_global(Config, deps_dir, "deps"),
    filename:join([".", DepsDir, App]).

deps_dirs(Dir) ->
    [D || D <- filelib:wildcard(Dir ++ "/*"), filelib:is_dir(D)].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copied from rebar_deps.erl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
download_source(AppDir, {git, Url}) ->
    download_source(AppDir, {git, Url, {branch, "HEAD"}});
download_source(AppDir, {git, Url, ""}) ->
    download_source(AppDir, {git, Url, {branch, "HEAD"}});
download_source(AppDir, {git, Url, {branch, Branch}}) ->
    ok = filelib:ensure_dir(AppDir),
    rebar_utils:sh(?FMT("git clone -n ~s ~s", [Url, filename:basename(AppDir)]),
                   [{cd, filename:dirname(AppDir)}]),
    rebar_utils:sh(?FMT("git checkout -q origin/~s", [Branch]), [{cd, AppDir}]);
download_source(AppDir, {git, Url, {tag, Tag}}) ->
    ok = filelib:ensure_dir(AppDir),
    rebar_utils:sh(?FMT("git clone -n ~s ~s", [Url, filename:basename(AppDir)]),
                   [{cd, filename:dirname(AppDir)}]),
    rebar_utils:sh(?FMT("git checkout -q ~s", [Tag]), [{cd, AppDir}]);
download_source(AppDir, {git, Url, Rev}) ->
    ok = filelib:ensure_dir(AppDir),
    rebar_utils:sh(?FMT("git clone -n ~s ~s", [Url, filename:basename(AppDir)]),
                   [{cd, filename:dirname(AppDir)}]),
    rebar_utils:sh(?FMT("git checkout -q ~s", [Rev]), [{cd, AppDir}]).

update_source1(AppDir, {git, Url}) ->
    update_source1(AppDir, {git, Url, {branch, "HEAD"}});
update_source1(AppDir, {git, Url, ""}) ->
    update_source1(AppDir, {git, Url, {branch, "HEAD"}});
update_source1(AppDir, {git, _Url, {branch, Branch}}) ->
    ShOpts = [{cd, AppDir}],
    rebar_utils:sh("git fetch origin", ShOpts),
    rebar_utils:sh(?FMT("git checkout -q origin/~s", [Branch]), ShOpts);
update_source1(AppDir, {git, _Url, {tag, Tag}}) ->
    ShOpts = [{cd, AppDir}],
    rebar_utils:sh("git fetch --tags origin", ShOpts),
    rebar_utils:sh(?FMT("git checkout -q ~s", [Tag]), ShOpts);
update_source1(AppDir, {git, _Url, Refspec}) ->
    ShOpts = [{cd, AppDir}],
    rebar_utils:sh("git fetch origin", ShOpts),
    rebar_utils:sh(?FMT("git checkout -q ~s", [Refspec]), ShOpts).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
