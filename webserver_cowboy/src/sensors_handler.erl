-module(sensors_handler).
-behavior(cowboy_handler).

-export([init/2, getSensorsDyn/0, checkConnection/1, getSensorValue/0]).

init(Req0, State) ->
	{ok, Body} = sensors_dtl:render([
		{template_name, "Sensors Manager"},
		{connection, checkConnection(nodes())},
		{sensors, getSensorsDyn()}
		]),
	{ok, Req2} = cowboy_req:reply(200, #{<<"content-type">> => <<"text/html">>}, Body, Req0),	
	{ok, Req2, State}.

getSensorsDyn() ->
	% First update ets:table with sensor status
	[{SensorName, SensorLocation, _}] = ets:match_object(sensortable, {mq2, '_', '_'}),
	ets:delete(sensortable, SensorName),
	ets:insert(sensortable, {SensorName, SensorLocation, getSensorValue()}),

	{[Result]} = parseData(ets:match_object(sensortable, {'_', '_', '_'}), []),
	Result.

parseData([], Sensors) ->
	AllSensors = [Sensors],
	{AllSensors};

parseData([Head|Tail], Sensors) ->
	AllSensors = lists:append(Sensors, parseDataProperties(Head)),
	parseData(Tail, AllSensors).

parseDataProperties(SensorProperties) ->
	{Name, Location, Value} = SensorProperties,

	SensorList = [
		% {"device_type", Type},
		{"sensor_name", Name},
		{"sensor_location", Location},
		{"sensor_status", Value}
	],
	ReturnList = [SensorList],
	ReturnList.

checkConnection([]) ->
		0;
	%% Als nodes() een lege lijst is, is er geen connectie met de erlang ale node
checkConnection([_|_]) ->
		1.


getSensorValue() ->
	%% From erlang ale process
	% net_kernel:connect_node('server@127.0.0.1'),
	% ServerPid = rpc:call('server@127.0.0.1', erlang, list_to_pid, ["<0.146.0>"]),
	Value = checkConnection(nodes()),
	if
	Value==0 ->
		0;
	true ->
		[{_, ErlangPid}] = ets:match_object(pipes, {serverpid, '_'}),
		[{_, ErlangNode}] = ets:match_object(pipes, {servernode, '_'}),

		ErlangNodePid = rpc:call(ErlangNode, erlang, list_to_pid, [ErlangPid]),
		ErlangNodePid ! {request, self(), 1},
		receive
			Sensor ->
				Sensor
		end
	end.
	

%github.com/erlydtl/erlydtl/wiki
%init(Req0, State) ->
%	erlydtl:compile("./priv/smurfin.html", smurfin_template),
%	smurfin_template:rend


