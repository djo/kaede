-module(kaede_dashboard_controller, [Req]).
-export([before_/3, index/3]).

before_(_, _, _) ->
    case member_lib:require_login(Req) of
        fail -> {redirect, "/member/login"};
        {ok, Member} -> {ok, Member}
    end.

index('GET', [], Member) ->
    {ok, [{member, Member}]}.
