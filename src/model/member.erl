-module(member, [Id, Email, Name, PasswordHash]).
-export([validation_tests/0, check_password/1, login_cookies/0, session_id/0]).
-define(SECRET_STRING, "upAS6qr88RVDYdS").

validation_tests() ->
    [{fun () -> length(Email) > 0 end, "Email is required"},
     {fun () -> length(Name) > 0 end, "Name is required"}].

check_password(Password) ->
    ComputedHash = kaede_auth:hash_for(Email, Password),
    PasswordHash =:= ComputedHash.

login_cookies() ->
    UserId = kaede_auth:root_cookie("user_id", Id),
    SessionId = kaede_auth:root_cookie("session_id", kaede_auth:session_id(Id)),
    [UserId, SessionId].

session_id() ->
    kaede_auth:session_id(Id).
