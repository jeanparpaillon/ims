%%% @author Jean Parpaillon <jean.parpaillon@free.fr>
%%% @copyright (C) 2014, Jean Parpaillon
%%% @doc
%%%
%%% @end
%%% Created : 18 Sep 2014 by Jean Parpaillon <jean.parpaillon@free.fr>
-module(ims).
-compile([{parse_transform, lager_transform}]).

-behaviour(application).

-export([start/0, 
	 stop/0]).

start() ->
    lager:info("Starting ICARE Media Server"),
    application:start(ims).

stop() ->
    lager:info("Stopping ICARE Media Server"),
    application:stop(ims).
