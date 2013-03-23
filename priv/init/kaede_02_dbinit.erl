-module (kaede_02_dbinit).

-export([init/0, migrate/0, rebuild/0, recreate_table/1]).

-define(APPNAME, kaede).
-define(MODELS, [list_to_atom(M) || M <- boss_files:model_list(?APPNAME)]).
-define(NODES, [node()]).

init() ->
    mnesia:stop(),
    mnesia:create_schema(?NODES),
    mnesia:change_table_copy_type(schema, node(), disc_copies),
    mnesia:start(),
    ExistingTables = mnesia:system_info(tables),
    TablesToCreate = (?MODELS ++ ['_ids_']) -- ExistingTables,
    [create_table   (T) || T <- TablesToCreate],
    [init_table_data(T) || T <- TablesToCreate],
    {ok, []}.

create_table('_ids_') ->
    create_table(?NODES, '_ids_', [type, id]);

create_table(Model) ->
    error_logger:info_msg("Installing table ~p",[Model]),
    DummyRecord = boss_record_lib:dummy_record(Model),
    Attributes = DummyRecord:attribute_names(),
    create_table(?NODES, Model, Attributes).

create_table(Nodes, Table, Attributes) ->
    mnesia:create_table(Table, [{attributes, Attributes},
                               {disc_copies, Nodes}]).

migrate() ->
    mnesia:stop(),
    init().

rebuild() ->
    mnesia:stop(),
    mnesia:delete_schema(?NODES),
    init().

recreate_table(Model) ->
    mnesia:delete_table(Model),
    create_table(Model).




init_table_data(Model) ->
    error_logger:info_msg("Insert into [~p]", [Model]),
    Items = try db_defaults:Model() of
		[] -> error_logger:info_msg("\tnothing to insert"),
		      [];
		Success -> Success
	    catch 
		_:_ -> error_logger:info_msg("\tnothing to insert"),
		       []
	    end,
    [save_item(Item) || Item <- Items].

save_item(Item) ->
    try Item:save() of
	{ok, Saved} -> error_logger:info_msg("\tok. ~p", [Saved]);
	Error -> error_logger:info_msg("\tfailed because: ~p", [Error])
    catch
	Error:Reason ->
	    error_logger:info_msg("\tfailed because: ~p", [{Error, Reason}])
    end.
