-module(kaede_main_controller, [Req]).
%-export([before_/3, main/2, topics_index/2,topic_create/2]).
-compile(export_all).


% Filters

% Here we filter some actions. Login needed to run that actions
% List of actions
% - topic_create
% If we fail to authenticate user then we redirect to member/login page
%  ( Maybe just show him flash message )
% Else we pass Member tuple? to the action

before_("topic_create",_,_) ->
    case member_lib:require_login(Req) of
            fail -> {redirect, "/member/login"};
            {ok, Member} -> {ok, Member}
    end;
% All other actions pass filter here.
before_(_,_,_) ->
        {ok, []}.

% Main page

main('GET', []) ->
   {ok,[]}.

% Here we will give list of topics in json format.
% Frontend needs to call this func to get the results and past them in template

topics_index('GET', []) ->
    Topics = boss_db:find(topic, []),
    {json, [{topics,Topics}]}.

% This will give info to angular about topic with some id
topic_show('GET',[Id]) ->
    Topic = boss_db:find(topic,[Id]),
    {json, [{topic, Topic}]}.

% Creating topics
% Recieve topic text from form and save it to db in topic table

topic_create('POST', []) ->
    TopicText = Req:post_param("topic_text"),
    NewTopic = topic:new(id, TopicText),
    case NewTopic:save() of
        {ok, SavedTopic} ->
            {redirect, [{action, "topics_list"}]}; % Here we need to show notice that topic was created
        {error, ErrorList} ->
            {ok, [{errors, ErrorList}, {new_msg, NewTopic}]}
    end.


