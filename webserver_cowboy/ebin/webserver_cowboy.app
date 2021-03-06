{application, 'webserver_cowboy', [
	{description, "Cowboy webserver with ErlyDTL framework"},
	{vsn, "0.1.0"},
	{modules, ['deviceaction_handler','devices_dtl','devices_handler','devices_old_dtl','sensors_dtl','sensors_handler','sensors_old_dtl','smurfin_dtl','webserver_cowboy_app','webserver_cowboy_sup']},
	{registered, [webserver_cowboy_sup]},
	{applications, [kernel,stdlib,cowboy,erlydtl]},
	{mod, {webserver_cowboy_app, []}},
	{env, []}
]}.