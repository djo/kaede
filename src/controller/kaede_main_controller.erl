-module(kaede_main_controller, [Req]).
-export([topics_list/2]).

before_(_) ->
    case member_lib:require_login(Req) of
		fail-> {redirect, "/member/login"};
		{ok, Member} -> {ok, Member}
    end.

topics_list('GET', []) ->
	Topics = boss_db:find(topic, []),
    {json, [{topics,Topics}]}.

% Will list our topics or better give json with topics
%list('GET', []) ->
%    Greetings = boss_db:find(greeting, []),
%    {ok, [{greetings, Greetings}]}.
