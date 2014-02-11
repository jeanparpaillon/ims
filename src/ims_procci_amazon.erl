%%% @author Jean Parpaillon <jean.parpaillon@free.fr>
%%% @copyright (C) 2014, Jean Parpaillon
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
%%% Created :  11 Feb 2014 by Jean Parpaillon <jean.parpaillon@free.fr>
-module(ims_procci_amazon).
-compile({parse_transform, lager_transform}).

-behaviour(occi_backend).

-include_lib("occi/include/occi.hrl").

%% occi_backend callbacks
-export([init/1,
	 terminate/1]).
-export([update/2,
	 save/2,
	 delete/2,
	 find/2,
	 load/2]).

-record(state, {}).

%%%===================================================================
%%% occi_backend callbacks
%%%===================================================================
init(_) ->
    {ok, #state{}}.

terminate(#state{}) ->
    ok.

save(#occi_node{}=_Node, State) ->
    {ok, State}.

delete(#occi_node{}=_Node, State) ->
    {ok, State}.

update(#occi_node{}=_Node, State) ->
    {ok, State}.

find(#occi_node{}=_Req, State) ->
    {{ok, []}, State}.

load(#occi_node{}=Req, State) ->
    {{ok, Req}, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
