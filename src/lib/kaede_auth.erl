-module(kaede_auth).
-export([root_cookie/2, session_id/1, require_login/1, hash_for/2]).
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

member_logged(Member, Req) ->
    case Member:session_id() =:= Req:cookie("session_id") of
        true -> {ok, Member};
        false -> fail
    end.
