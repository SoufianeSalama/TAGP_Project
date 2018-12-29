-module(devices_handler).
-behavior(cowboy_handler).

-export([init/2, getDevicesDyn/0, parseData/2, parseDataProperties/1]).

init(Req0, State) ->
	{ok, Body} = devices_dtl:render([
		{template_name, "Devices Manager"},
		
		{devices, getDevicesDyn()}

		]),
	{ok, Req2} = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, Body, Req0),	
	{ok, Req2, State}.


getDevicesDyn() ->
	% DevicesTable = ets:new(elementen, [bag]),%% Type, Name, Location, Status, GPIO
	% ets:insert(DevicesTable, {device, verwarming, binnen, 1, 18}),
	% ets:insert(DevicesTable, {device, pomp, buiten, 1, 23}),
	% ets:insert(DevicesTable, {device, oven, keuken, 0, 27}),
	% ets:insert(DevicesTable, {device, tuinlichten, tuin, 1, 25}),
	% {[Result]} = parseData(ets:lookup(DevicesTable, device), []),
	% Result.
	% ets:new(devicetable, [named_table, bag]),%% Type, Name, Location, Status, GPIO
	% ets:insert(devicetable, {verwarming, binnen, 1, 18}),
	% ets:insert(devicetable, {pomp, buiten, 1, 23}),
	% ets:insert(devicetable, {oven, keuken, 0, 27}),
	% ets:insert(devicetable, {tuinlicht, tuin, 1, 25}),
	{[Result]} = parseData(ets:match_object(devicetable, {'_', '_', '_', '_'}), []),
	Result.

parseData([], Devices) ->
	AllDevices = [Devices],
	{AllDevices};

parseData([Head|Tail], Devices) ->
	AllDevices = lists:append(Devices, parseDataProperties(Head)),
	parseData(Tail, AllDevices).

parseDataProperties(DeviceProperties) ->
	% {Type, Name, Location, Status, Gpio} = DeviceProperties,
	{Name, Location, Status, Gpio} = DeviceProperties,
	DeviceList = [
		% {"device_type", Type},
		{"device_name", Name},
		{"device_location", Location},
		{"device_status", Status},
		{"device_gpio", Gpio}
	],
	ReturnList = [DeviceList],
	ReturnList.










%getDevicesStatic() ->
%	[
%		[
%		{device_name, "pomp"},
%		{device_description, "..."},
%		{device_location, "buiten"},
%		{device_status, "1"}
%		],
%
%		[
%		{device_name, "verwarming"},
%		{device_description, "..."},
%		{device_location, "binnen"},
%		{device_status, "1"}
%		]
%	].




%github.com/erlydtl/erlydtl/wiki
%init(Req0, State) ->
%	erlydtl:compile("./priv/smurfin.html", smurfin_template),
%	smurfin_template:rend


%{devices, [
		%	"Verwarming",
		%	"Oven",
		%	"Pomp",
		%	"Tuinlichten"
		%	]}
		%]),
