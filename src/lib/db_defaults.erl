%%% provides methods for initial database data
%%% if you need some pre-defined data in your model's table
%%% you should define a parameterless method
%%% with the name similar to the model's name
%%% and return constructed entity list

-module(db_defaults).
-compile(export_all).

member() ->
    Hash = member_lib:hash_for("john@email.com", "password"),
    [member:new(id, "john@email.com", "John", Hash)].

tag() ->
    TagNames = ["me", "weather", "cats", "work", "justsaying"],
    lists:map(fun (Text) -> tag:new(id, Text) end, TagNames).
