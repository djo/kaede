-module(kaede_main_controller, [Req]).
-export([before_/3, main/2, topics_index/2,topic_create/2]).

before_("topic_create",_,_) ->
    case member_lib:require_login(Req) of
            fail -> {redirect, "/member/login"};
            {ok, Member} -> {ok, Member}
    end;
before_(_,_,_) ->
        {ok, []}.

% Main page

main('GET', []) ->
   {ok,[]}.

% Listing topics here

topics_index('GET', []) ->
    Topics = boss_db:find(topic, []),
    {ok, [{topics,Topics}]}.

% List individual topic
topic_show('GET',[Id]) ->
    Topic = boss_db:find(topic,[Id]),
    {ok, [{topic, Topic}]}.

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


