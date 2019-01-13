-module(webserver_cowboy_sup).
-behaviour(supervisor).
 
-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	ets:new(devicetable, [named_table, bag, public]),%% Name, Location, Status, GPIO
	ets:insert(devicetable, {verwarming, binnen, 0, 18}),
	ets:insert(devicetable, {pomp, buiten, 0, 23}),
	ets:insert(devicetable, {oven, keuken, 0, 24}),
	ets:insert(devicetable, {tuinlichten, tuin, 0, 22}),
	ets:insert(devicetable, {tv, tuin, 0, 27}),

	ets:new(sensortable, [named_table, bag, public]),%% Name, Location, Status, GPIO
	ets:insert(sensortable, {mq2, binnen, nodata}),

	ets:new(pipes, [named_table, public]),%% Type, Name, Location, Status, GPIO
	ets:insert(pipes, {servernode, 'server@127.0.0.1'}),



	Procs = [],
	{ok, {{one_for_one, 1, 5}, Procs}}.
