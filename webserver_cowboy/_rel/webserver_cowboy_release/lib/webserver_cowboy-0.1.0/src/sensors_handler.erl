-module(sensors_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
	{ok, Body} = sensors_dtl:render([
		{template_name, "Sensors Manager"},
		{sensors, [
			<<"Waterniveau">>,
			<<"Beweging">>,
			<<"Luchtkwaliteit">>,
			<<"Deur">>
			]}
		]),
	{ok, Req2} = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, Body, Req0),	
	{ok, Req2, State}.

%github.com/erlydtl/erlydtl/wiki
%init(Req0, State) ->
%	erlydtl:compile("./priv/smurfin.html", smurfin_template),
%	smurfin_template:rend
