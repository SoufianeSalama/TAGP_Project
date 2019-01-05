-module(webserver_cowboy_sup).
-behaviour(supervisor).
 
-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	ets:new(devicetable, [named_table, bag, public]),%% Name, Location, Status, GPIO
	ets:insert(devicetable, {verwarming, binnen, 1, 18}),
	ets:insert(devicetable, {pomp, buiten, 1, 23}),
	ets:insert(devicetable, {oven, keuken, 0, 27}),
	ets:insert(devicetable, {tuinlichten, tuin, 1, 25}),

	ets:new(sensortable, [named_table, bag, public]),%% Name, Location, Status, GPIO
	ets:insert(sensortable, {pir, binnen, analog, 0}),
	ets:insert(sensortable, {mq2, binnen, analog, 0}),

	ets:new(pipes, [named_table, public]),%% Type, Name, Location, Status, GPIO


	Procs = [],
	{ok, {{one_for_one, 1, 5}, Procs}}.
