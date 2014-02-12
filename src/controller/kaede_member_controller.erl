-module(kaede_member_controller, [Req,SessionID]).
-export([register/2, logout/2, login/2]).

register('GET', []) ->
    {ok, []};
register('POST', []) ->
    Email = Req:post_param("email"),
    Name = Req:post_param("name"),
    Password = Req:post_param("password1"),
    Password2 = Req:post_param("password2"),
    case member_lib:add_member(Name, Email, Password, Password2) of
        {ok, Member} ->
            login_and_redirect(Member);
        {error, Errors} ->
            {ok, [{errors, Errors},
                {name, Name},
                {email, Email},
                {password1, Password},
                {password2, Password2}]}
    end.

logout('GET', []) ->
    case Req:cookie("_boss_session") of
        SessionID ->
            Cookies = [member_lib:root_cookie("user_id", ""), member_lib:root_cookie("session_id", "")],
            {redirect, "/", Cookies};
        _ ->
            {redirect, "/"}
    end.

login('GET', []) ->
    {ok, [{redirect, Req:header(referer)}]};
login('POST', []) ->
    Email = Req:post_param("email"),
    Password = Req:post_param("password"),
    case boss_db:find(member, [{email, 'equals', Email}]) of
        [Member] ->
            case Member:check_password(Password) of
                true -> login_and_redirect(Member);
                false -> {ok, [{error, "Wrong password"}]}
            end;
        [] ->
            {ok, [{error, "User with email " ++ Email ++ " not found: "}]}
    end.

login_and_redirect(Member) ->
    Cookies = Member:login_cookies(),
    RedirectTo = "/",
    {redirect, RedirectTo, Cookies}.

 