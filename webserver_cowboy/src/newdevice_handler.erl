-module(newdevice_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, Opts) ->
	Method = cowboy_req:method(Req0),
	HasBody = cowboy_req:has_body(Req0),
	Req = maybe_echo(Method, HasBody, Req0),
	{ok, Req, Opts}.

maybe_echo(<<"POST">>, true, Req0) ->
	{ok, PostVals, Req} = cowboy_req:read_urlencoded_body(Req0),
	DeviceName = proplists:get_value(<<"devicename">>, PostVals),
	DeviceLocation = proplists:get_value(<<"devicelocation">>, PostVals),
	DeviceGpio = proplists:get_value(<<"devicegpio">>, PostVals),
	% io:format("Echo: ~nName: ~p, Loc: ~p, Gpio: ~p~n", [DeviceName,DeviceLocation,DeviceGpio]),
	echo(DeviceName, DeviceLocation,DeviceGpio, Req);

maybe_echo(<<"POST">>, false, Req) ->
	cowboy_req:reply(400, [], <<"Missing body.">>, Req);

maybe_echo(_, _, Req) ->
	% Method not allowed.
	cowboy_req:reply(405, Req).

echo(undefined, undefined, undefined, Req) ->
	cowboy_req:reply(400, [], <<"Missing devices parameters.">>, Req);

echo(DeviceName, DeviceLocation, DeviceGpio, Req) ->
	io:format("New device: ~p~n", [DeviceGpio]),

	ets:insert(devicetable, {binary_to_atom(DeviceName, latin1), binary_to_atom(DeviceLocation, latin1), 0, list_to_integer(binary_to_list(DeviceGpio))}),
	cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain; charset=utf-8">>
	},[DeviceName,DeviceLocation,DeviceGpio], Req).
