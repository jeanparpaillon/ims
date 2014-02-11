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
-define(SCHEME_TRANSCODE, 'http://schemas.itea-icare.org/occi/transcoding#').
-define(SCHEME_JOB, 'http://schemas.itea-icare.org/occi/transcoding/job#').

-export([start/0,
	 stop/0,
	 loop/0]).

start() ->
    application:start(occi),
    Mapping = [
	       {#occi_cid{scheme=?SCHEME_TRANSCODE, term='job', class=kind}, "/jobs/"}
	      ],
    Extensions = {extensions,
		  [{xml, "schemas/occi-transcode.xml"}], 
		  Mapping},
    Backends = {backends, 
		[{mnesia, ims_procci_amazon, [], "/"}]},
    Listeners = {listeners, 
		 [{http, occi_http, [{port, 8080}]}]
		},
    Handlers = {handlers, 
		[{pid, self()}]},
    occi:config([{name, "http://localhost:8080"},
		 Extensions, 
		 Backends,
		 Listeners,
		 Handlers]),
    register(?MODULE, self()),
    loop().

stop() ->
    application:stop(occi),
    ?MODULE ! stop.

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
