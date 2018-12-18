-module(devices_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
	%Devicestable = ets:new(devicestable, []),
	%ets:insert(Devicestable, [{Verwarming}],
	%ets:insert(Devicestable, [{Oven}],
	%ets:insert(Devicestable, [{Pomp}],
	%ets:insert(Devicestable, [{Tuinlichten}],
	{ok, Body} = devices_dtl:render([
		{template_name, "Devices Manager"},
		
		{devices, 
			[
				[
				{device_name, "pomp"},
				{device_description, "..."},
				{device_location, "buiten"},
				{device_status, "1"}
				],

				[
				{device_name, "verwarming"},
				{device_description, "..."},
				{device_location, "binnen"},
				{device_status, "1"}
				]
			]
		}
		]),
	{ok, Req2} = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, Body, Req0),	
	{ok, Req2, State}.

%github.com/erlydtl/erlydtl/wiki
%init(Req0, State) ->
%	erlydtl:compile("./priv/smurfin.html", smurfin_template),
%	smurfin_template:rend


%{devices, [
		%	"Verwarmingennnnn",
		%	"Oven",
		%	"Pomp",
		%	"Tuinlichten"
		%	]}
		%]),
