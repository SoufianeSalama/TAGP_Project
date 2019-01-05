-module(addpid_handler).
-behavior(cowboy_handler).

-export([init/2, makeConnection/1]).

init(Req0, Opts) ->
	Method = cowboy_req:method(Req0),
	HasBody = cowboy_req:has_body(Req0),
	Req = maybe_echo(Method, HasBody, Req0),
	{ok, Req, Opts}.

maybe_echo(<<"POST">>, true, Req0) ->
	{ok, PostVals, Req} = cowboy_req:read_urlencoded_body(Req0),
	PID = proplists:get_value(<<"pid">>, PostVals),
	NodeName = proplists:get_value(<<"node">>, PostVals),
	echo(PID,NodeName, Req);

maybe_echo(<<"POST">>, false, Req) ->
	cowboy_req:reply(400, [], <<"Missing body.">>, Req);

maybe_echo(_, _, Req) ->
	% Method not allowed.
	cowboy_req:reply(405, Req).

echo(undefined,undefined, Req) ->
	cowboy_req:reply(400, [], <<"Missing connection parameters.">>, Req);

echo(PID,NodeName, Req) ->
	ets:insert(pipes, {serverpid, binary_to_atom(PID, latin1)}),
	ets:insert(pipes, {servernodename, binary_to_atom(NodeName, latin1)}),
	io:format("PID: ~p~nNode: ~p~n", [binary_to_atom(PID, latin1), binary_to_atom(NodeName, latin1)]),
	makeConnection(NodeName),
	cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain; charset=utf-8">>
	},[PID,NodeName], Req).

makeConnection(NodeName) ->
	net_kernel:connect_node(binary_to_atom(NodeName, latin1)).
