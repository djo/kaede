-module(kaede_main_controller, [Req]).
-compile(export_all).

before_(_) ->
    case member_lib:require_login(Req) of
		fail-> {redirect, "/member/login"};
		{ok, Member} -> {ok, Member}
    end.

% Заглушка
hello('GET', []) ->
    {output, "<strong>Rahm says hello!</strong>"}.

% Will list our topics or better give json with topics
%list('GET', []) ->
%    Greetings = boss_db:find(greeting, []),
%    {ok, [{greetings, Greetings}]}.
