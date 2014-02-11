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

-define(SRV_NAME, "http://localhost").
-define(SRV_PORT, 8081).
-define(SCHEME_TRANSCODE, 'http://schemas.icare-itea.org/occi/transcode#').
-define(SCHEME_JOB, 'http://schemas.icare-itea.org/occi/transcode/job#').

-export([start/2, stop/1]).

-export([start/0,
	 stop/0,
	 loop/0]).

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
	       {#occi_cid{scheme=?SCHEME_TRANSCODE, term=job, class=kind}, "/jobs/"}
	      ],
    Extensions = {extensions,
		  [{xml, "schemas/occi-transcode.xml"}], 
		  Mapping},
    Backends = {backends, 
		[{mnesia, ims_procci_amazon, [], "/"}]},
    Listeners = {listeners, 
		 [{http, occi_http, [{port, ?SRV_PORT}]}]
		},
    Handlers = {handlers, 
		[{pid, self()}]},
    occi:config([{name, ?SRV_NAME ++ integer_to_list(?SRV_PORT)},
		 Extensions, 
		 Backends,
		 Listeners,
		 Handlers]),
    register(?MODULE, self()),
    loop().

stop(State) ->
    application:stop(occi),
    State.

loop() ->
    receive
	stop ->
	    exit(the_end);
	{Pid, #occi_action{id=ActionId}, #occi_node{id=Id}} ->
	    lager:info("Apply action: ~p(~p)~n", [lager:pr(ActionId, ?MODULE),
						  lager:pr(Id, ?MODULE)]),
	    Pid ! false;
	_ ->
	    erlang:hibernate(?MODULE, loop, [])
    end.
