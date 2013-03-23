-module(kaede_main_controller, [Req]).
%-compile(export_all).
-export([before_/3,hello/2,test_auth/0]).

before_("test_auth",_,_) ->
    case member_lib:require_login(Req) of
		fail-> {redirect, "/member/login"};
		{ok, Member} -> {ok, Member}
    end;
before_(_,_,_) ->
  		{ok, []}.

% Заглушка
hello('GET', []) ->
    {output, "<strong>Rahm says hello!</strong>"}.


test_auth() ->
   {ok,[]}.
% Will list our topics or better give json with topics
%list('GET', []) ->
%    Greetings = boss_db:find(greeting, []),
%    {ok, [{greetings, Greetings}]}.
