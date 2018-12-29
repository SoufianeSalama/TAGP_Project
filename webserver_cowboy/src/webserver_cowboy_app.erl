-module(webserver_cowboy_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([	
	{'_', [
		{"/", devices_handler, []},
	
		{"/devicesdynamic", devices_handler, []},
		{"/sensorsdynamic", sensors_handler, []},

		{"/deviceaction", deviceaction_handler, []},		
		{"/newdevice", newdevice_handler, []},		
	
		{"/devices", cowboy_static, {priv_file, webserver_cowboy, "devices.html"}},
		{"/devices.css", cowboy_static, {priv_file, webserver_cowboy, "devices.css"}},
		{"/devices.js", cowboy_static, {priv_file, webserver_cowboy, "devices.js"}},		

		{"/sensors", cowboy_static, {priv_file, webserver_cowboy, "sensors.html"}},
		{"/sensors.css", cowboy_static, {priv_file, webserver_cowboy, "sensors.css"}},
		{"/sensors.js", cowboy_static, {priv_file, webserver_cowboy, "sensors.js"}}
	]}


	]),
	{ok, _} = cowboy:start_clear(my_http_listener,
		[{port, 8080}],
		#{env => #{dispatch => Dispatch}}
	),
	webserver_cowboy_sup:start_link().
	
stop(_State) ->
	ok.

