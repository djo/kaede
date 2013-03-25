-module(kaede_topic_controller, [Req]).
-export([before_/3, index/2, show/2, create/2]).

before_("create", _, _) ->
    case member_lib:require_login(Req) of
        fail -> {redirect, "/member/login"};
        {ok, Member} -> {ok, Member}
    end;
before_(_, _, _) ->
    {ok, []}.

index('GET', []) ->
    Topics = boss_db:find(topic, []),
    {ok, [{topics, Topics}]}.

show('GET', [Id]) ->
    Topic = boss_db:find(topic, [Id]),
    {ok, [{topic, Topic}]}.

create('POST', []) ->
    TopicText = Req:post_param("topic_text"),
    NewTopic = topic:new(id, TopicText),
    case NewTopic:save() of
        {ok, SavedTopic} ->
            {redirect, [{action, "index"}]};
        {error, ErrorList} ->
            {ok, [{errors, ErrorList}, {new_msg, NewTopic}]}
    end.
