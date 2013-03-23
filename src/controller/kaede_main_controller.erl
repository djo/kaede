-module(kaede_main_controller, [Req]).
-export([before_/3, hello/2, test_auth/0, topics_list/2]).

before_("test_auth",_,_) ->
    case member_lib:require_login(Req) of
		    fail -> {redirect, "/member/login"};
		    {ok, Member} -> {ok, Member}
    end;
before_(_,_,_) ->
  		{ok, []}.

topics_list('GET', []) ->
	Topics = boss_db:find(topic, []),
    {json, [{topics,Topics}]}.

hello('GET', []) ->
    {output, "<strong>Rahm says hello!</strong>"}.

test_auth() ->
   {ok,[]}.
