-module(smurf_handler).
-behavior(cowboy_handler).

%-export([init/3]).
-export([init/2]).
%-export([handle/2]).
%-export([terminate/3]).

%-record(state, {}).

%init(_, Req, _Opts) ->
%	{ok, Req, #state{}}.

%init(Req, State) ->
%	{ok, Req, State).

%handle(Req, State=#state{}) ->
%	{ok, Body} = smurfin_dtl:render([{smurf_name, "Soufiane Salama"}]),
%	{ok, Req2} = cowboy_req:reply(200, [{<<"content-type">>, <<"text/html">>}], Body, Req),
%	{ok, Req2, State}.

%terminate(_Reason, _Req, _State) ->
%	ok.

init(Req0, State) ->
	{ok, Body} = smurfin_dtl:render([{smurf_name, "SoufianeSalama"}]),
	{ok, Req2} = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, Body, Req0),	
	{ok, Req2, State}.

%github.com/erlydtl/erlydtl/wiki
%init(Req0, State) ->
%	erlydtl:compile("./priv/smurfin.html", smurfin_template),
%	smurfin_template:rend
