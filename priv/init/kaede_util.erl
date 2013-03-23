-module (kaede_util).
-compile (export_all).
-define (APPNAME, kaede). % is it possible to get it automatically somewhere in CB?

init() ->
  init_db (),
  ok.

init_db () ->
  init_db ([node ()]). % only for local node? what about nodes()++[node()]?
init_db (Nodes) ->
  mnesia:create_schema (Nodes),
  mnesia:change_table_copy_type (schema, node(), disc_copies), % only for local node?
  mnesia:start (),
  ModelList = [ list_to_atom (M) || M <- boss_files:model_list (?APPNAME) ],
  ExistingTables = mnesia:system_info(tables),
  Tables = (ModelList ++ ['_ids_']) -- ExistingTables,
  Result = create_model_tables (Nodes, Tables),
  lists:map(fun init_table_data/1, Tables),
  Result.

% create all the tables
create_model_tables (_, []) -> ok;
create_model_tables (Nodes, [Model | Models]) ->
  [create_model_table (Nodes, Model)] ++
   create_model_tables (Nodes, Models).

% specific tables (not generated from model)
create_model_table (Nodes, '_ids_') ->
  create_table (Nodes, '_ids_', [type, id]);

% tables generated from model
create_model_table (Nodes, Model) ->
    Record = boss_record_lib:dummy_record (Model),
    { Model, create_table (Nodes, Model, Record:attribute_names ()) }.

% single table creator wrapper
create_table (Nodes, Table, Attribs) ->
  mnesia:create_table (Table,
    [ { disc_copies, Nodes   },
      { attributes,  Attribs } ]).

init_table_data(Model) ->
    Items = try db_defaults:Model() of
		Success -> Success
	    catch 
		_:_ -> [] 
	    end,
    init_table_data(Model, Items).

init_table_data(Model, []) -> ok;
init_table_data(Model, [Item|Rest]) ->
    error_logger:info_msg("Insert into [~p]\t ~p", [Model, Item]),
    Saved = Item:save(),
    error_logger:info_msg("ok"),
    init_table_data(Model, Rest).
    
