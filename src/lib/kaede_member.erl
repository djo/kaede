-module(kaede_member).
-export([create/4]).

create(Name, Email, Password, Confirmation) ->
    case boss_db:find(member, [{email, 'equals', Email}]) of
        [] ->
            case Password of
                Confirmation -> save_member(Email, Name, Password);
                _ -> {error, ["Passwords should be equal"]}
            end;
        _ ->
            {error, ["User already exists"]}
    end.

save_member(Email, Name, Password) ->
    PasswordHash = kaede_auth:hash_for(Email, Password),
    Member = member:new(id, Email, Name, PasswordHash),
    case Member:save() of
        {ok, Saved} -> {ok, Saved};
        {error, Errors} -> {error, Errors}
    end.
