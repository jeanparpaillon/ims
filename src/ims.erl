%%% @author Jean Parpaillon <jean.parpaillon@free.fr>
%%% @copyright (C) 2014, Jean Parpaillon
%%% @doc
%%%
%%% @end
%%% Created : 28 Jan 2014 by Jean Parpaillon <jean.parpaillon@free.fr>

-module(ims).
-compile([{parse_transform, lager_transform}]).

-behaviour(application).

-include_lib("occi/include/occi.hrl").

-define(BASE, <<"http://localhost:8080">>).
-define(SCHEME_INFRA, 'http://schemas.ogf.org/occi/infrastructure#').
-define(SCHEME_NET, 'http://schemas.ogf.org/occi/infrastructure/network#').
-define(SCHEME_NET_IF, 'http://schemas.ogf.org/occi/infrastructure/networkinterface#').

% application behaviour callback
-export([start/2,
	 stop/1]).

% Wrappers
-export([start/0, 
	 stop/0, 
	 loop/0]).
%% Hooks
-export([on_save/1, on_update/2, on_delete/1, on_action/2]).

start() ->
    {ok, Pid} = start(normal, []),
    register(?MODULE, Pid),
    erlang:hibernate(?MODULE, loop, []).

stop() ->
    stop(ok),
    ?MODULE ! stop.

start(_StartType, _StartArgs) ->
    application:start(occi),
    Mapping = [
	       {#occi_cid{scheme=?SCHEME_INFRA, term='compute', class=kind}, 
		{"/compute/", mnesia}},
	       {#occi_cid{scheme=?SCHEME_INFRA, term='storage', class=kind}, 
		{"/storage/", mnesia}},
	       {#occi_cid{scheme=?SCHEME_INFRA, term='storagelink', class=kind}, 
		{"/storagelink/", mnesia}},
	       {#occi_cid{scheme=?SCHEME_INFRA, term='network', class=kind},
		{"/network/", mnesia}},
	       {#occi_cid{scheme=?SCHEME_INFRA, term='networkinterface', class=kind}, 
		{"/networkinterface/", mnesia}},
	       {#occi_cid{scheme=?SCHEME_NET, term='ipnetwork', class=mixin},
		{"/ipnetwork/", mnesia}},
	       {#occi_cid{scheme=?SCHEME_NET_IF, term='ipnetworkinterface', class=mixin}, 
		{"/ipnetworkinterface/", mnesia}},
	       {#occi_cid{scheme=?SCHEME_INFRA, term='os_tpl', class=mixin},
		{"/os_tpl/", mnesia}},
	       {#occi_cid{scheme=?SCHEME_INFRA, term='resource_tpl', class=mixin},
		{"/resource_tpl/", mnesia}}
	      ],
    Extensions = {extensions,
		  [{xml, "schemas/occi-infrastructure.xml"}], 
		  Mapping},
    Backends = {backends, 
		[{mnesia, occi_backend_mnesia, []}]},
    Listeners = {listeners, 
		 [{http, occi_http, [{port, 8080}]}]
		},
    occi:config([{name, "http://localhost:8080"},
		 Extensions, 
		 Backends,
		 Listeners]),
    {ok, self()}.

stop(State) ->
    application:stop(occi),
    State.

loop() ->
    receive
	stop ->
	    exit(the_end);
	_ ->
	    erlang:hibernate(?MODULE, loop, [])
    end.

%%%
%%% Hooks
%%%
-spec on_save(occi_entity()) -> {reply, occi_entity()} | noreply.
on_save(Obj) ->
    {reply, Obj}.

-spec on_update(occi_entity(), occi_entity()) -> {reply, occi_entity()} | noreply.
on_update(_Old, New) ->
    {reply, New}.

-spec on_delete(occi_entity()) -> reply | noreply.
on_delete(Obj) ->
    {reply, Obj}.

-spec on_action(occi_entity(), any()) -> {reply, occi_entity()} | reply.
on_action(Obj, _Action) ->
    {reply, Obj}.
