-module(kaede_member).
-export([create/3]).

create(Email, Name, Password) ->
    Member = member:new(id, Email, Name, Password),
    Member:save().
