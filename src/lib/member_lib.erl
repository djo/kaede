-module(member_lib).
-export([root_cookie/2, session_id/1, add_member/4, require_login/1, hash_for/2]).
-define(SECRET_STRING, "Secret string").

hash_password(Password, Salt) ->
    mochihex:to_hex(erlang:md5(Salt ++ Password)).

hash_for(Login, Password) ->
    Salt = mochihex:to_hex(erlang:md5(Login)),
    ComputedHash = hash_password(Password, Salt),
    ComputedHash.

root_cookie(N, V) ->
    mochiweb_cookies:cookie(N, V, [{path, "/"}]).

session_id(Id) ->
    mochihex:to_hex(erlang:md5(?SECRET_STRING ++ Id)).

add_member(Name, Email, Password, Confirmation) ->
    case boss_db:find(member, [{email, 'equals', Email}]) of
        [] ->
            case Password of
                Confirmation -> save_member(Email, Name, Password);
                _ -> {error, ["Passwords should be equal"]}
            end;
        _ ->
            {error, ["User already exists"]}
    end.

require_login(Req) ->
    case Req:cookie("user_id") of
        undefined ->
            fail;
        Id ->
            case boss_db:find(Id) of
                undefined -> fail;
                Member -> member_logged(Member, Req)
            end
    end.

save_member(Email, Name, Password) ->
    PasswordHash = hash_for(Email, Password),
    Member = member:new(id, Email, Name, PasswordHash),
    case Member:save() of
        {ok, Saved} -> {ok, Saved};
        {error, Errors} -> {error, Errors}
    end.

member_logged(Member, Req) ->
    case Member:session_id() =:= Req:cookie("session_id") of
        true -> {ok, Member};
        false -> fail
    end.
