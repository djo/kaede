-module(kaede_dashboard_controller, [Req]).
-export([before_/3, index/3]).

before_(_, _, _) ->
    case kaede_auth:require_login(Req) of
        {ok, Member} -> {ok, Member};
        fail -> {redirect, "/member/login"}
    end.

index('GET', [], Member) ->
    {ok, [{member, Member}]}.
