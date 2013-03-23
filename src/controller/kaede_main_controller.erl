-module(kaede_main_controller, [Req]).
-export([before_/3, topics_list/2]).

before_("test_auth",_,_) ->
    case member_lib:require_login(Req) of
            fail -> {redirect, "/member/login"};
            {ok, Member} -> {ok, Member}
    end;
before_(_,_,_) ->
        {ok, []}.

% Listing topics here

topics_list('GET', []) ->
    Topics = boss_db:find(topic, []),
    {json, [{topics,Topics}]}.

% Creating topics

% Show form
topic_create('GET',  []) -> ok;

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


hello('GET', []) ->
    {output, "<strong>Rahm says hello!</strong>"}.

test_auth() ->
   {ok,[]}.
