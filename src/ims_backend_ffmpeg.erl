%%% @author Jean Parpaillon <jean.parpaillon@free.fr>
%%% @copyright (C) 2013, Jean Parpaillon
%%% 
%%% This file is provided to you under the Apache License,
%%% Version 2.0 (the "License"); you may not use this file
%%% except in compliance with the License.  You may obtain
%%% a copy of the License at
%%% 
%%%   http://www.apache.org/licenses/LICENSE-2.0
%%% 
%%% Unless required by applicable law or agreed to in writing,
%%% software distributed under the License is distributed on an
%%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%%% KIND, either express or implied.  See the License for the
%%% specific language governing permissions and limitations
%%% under the License.
%%% 
%%% @doc
%%%
%%% @end
%%% Created :  18 Sep 2014 by Jean Parpaillon <jean.parpaillon@free.fr>
-module(ims_backend_ffmpeg).
-compile({parse_transform, lager_transform}).

-behaviour(occi_backend).

-include_lib("erocci_core/include/occi.hrl").

%% occi_backend callbacks
-export([init/1,
	 terminate/1]).
-export([update/2,
	 save/2,
	 delete/2,
	 find/2,
	 load/3,
	 action/3]).

-define(schema, "occi-transcode.xml").

-record(state, {}).

%%%===================================================================
%%% occi_backend callbacks
%%%===================================================================
init(#occi_backend{opts=_Opts}) ->
    case code:priv_dir(ims) of
	{error, bad_name} ->
	    {error, "Can not find schema"};
	Dir ->
	    Schema = filename:join([Dir, "schemas", ?schema]),
	    {ok, [{schemas, [{path, Schema}]}]}
    end.


terminate(#state{}) ->
    ok.

save(State, #occi_node{}=Obj) ->
    lager:info("[~p] save(~p)~n", [?MODULE, Obj#occi_node.id]),
    {ok, State}.

delete(State, #occi_node{}=Obj) ->
    lager:info("[~p] delete(~p)~n", [?MODULE, Obj#occi_node.id]),
    {ok, State}.

update(State, #occi_node{}=Node) ->
    lager:info("[~p] update(~p)~n", [?MODULE, Node#occi_node.id]),
    {ok, State}.

find(State, #occi_node{}=Obj) ->
    lager:info("[~p] find(~p)~n", [?MODULE, Obj#occi_node.id]),
    {{ok, Obj}, State}.

load(State, #occi_node{}=Node, _Opts) ->
    lager:info("[~p] load(~p)~n", [?MODULE, Node#occi_node.id]),
    {{ok, Node}, State}.

action(State, #uri{}=Id, #occi_action{}=A) ->
    lager:info("[~p] action(~p, ~p)~n", [?MODULE, Id, A]),
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
