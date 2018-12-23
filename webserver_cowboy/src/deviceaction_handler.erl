-module(deviceaction_handler).
-behavior(cowboy_handler).

-export([init/2, changeDeviceStatus/2]).

init(Req0, Opts) ->
	Method = cowboy_req:method(Req0),
	HasBody = cowboy_req:has_body(Req0),
	%io:format("Method: ~p, HasBody: ~p~n", [Method, HasBody]),
	Req = maybe_echo(Method, HasBody, Req0),
	{ok, Req, Opts}.

maybe_echo(<<"POST">>, true, Req0) ->
	{ok, PostVals, Req} = cowboy_req:read_urlencoded_body(Req0),
	%Echo = proplists:get_value(<<"echo">>, PostVals),
	DeviceName = proplists:get_value(<<"devicename">>, PostVals),
	DeviceStatus = proplists:get_value(<<"devicestatus">>, PostVals),
	%io:format("Echo: ~p~n", [PostVals]).
	%echo(Echo, Req);
	echo(DeviceName, DeviceStatus, Req);

maybe_echo(<<"POST">>, false, Req) ->
	cowboy_req:reply(400, [], <<"Missing body.">>, Req);

maybe_echo(_, _, Req) ->
	% Method not allowed.
	cowboy_req:reply(405, Req).

%echo(undefined, Req) ->
	%cowboy_req:reply(400, [], <<"Missing echo parameter.">>, Req);

%echo(Echo, Req) ->
	%cowboy_req:reply(200, #{
	%	<<"content-type">> => <<"text/plain; charset=utf-8">>
	%}, Echo, Req).

echo(undefined, undefined, Req) ->
	cowboy_req:reply(400, [], <<"Missing devices parameters.">>, Req);

echo(DeviceName, DeviceStatus,Req) ->
	io:format("Devicename: ~p~nDeviceStatus: ~p~n", [DeviceName, DeviceStatus]),
	net_kernel:connect_node('server@127.0.0.1'),
	ServerPid = rpc:call('server@127.0.0.1', erlang, list_to_pid, ["<0.154.0>"]),
	%%ServerPid ! on,
	changeDeviceStatus(DeviceStatus, ServerPid),
	cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain; charset=utf-8">>
	},[DeviceName,DeviceStatus], Req).

changeDeviceStatus(<<"1">>, ServerPid) ->
	ServerPid ! on;
changeDeviceStatus(<<"0">>, ServerPid) ->
	ServerPid ! off;
changeDeviceStatus(_, ServerPid) ->
	ServerPid.
