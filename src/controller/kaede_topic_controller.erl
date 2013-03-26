-module(kaede_topic_controller, [Req]).
-export([before_/3, index/3, poll/3, create/3]).

before_(_, _, _) ->
    case member_lib:require_login(Req) of
        fail -> {redirect, "/member/login"};
        {ok, Member} -> {ok, Member}
    end.

index('GET', [], Member) ->
    Topics = boss_db:find(topic, []),
    MQTopics = lists:map(fun(Topic) -> topic_mq:build(Topic, Member) end, Topics),
    Timestamp = boss_mq:now("new-topics"),
    {json, [{topics, MQTopics}, {timestamp, Timestamp}]}.

poll('GET', [Timestamp], Member) ->
    {ok, NewTimestamp, Topics} = boss_mq:pull("new-topics",
        list_to_integer(Timestamp)),
    {json, [{timestamp, NewTimestamp}, {topics, Topics}]}.

create('POST', [], Member) ->
    TopicText = Req:post_param("topic_text"),
    Topic = topic:new(id, TopicText),
    case Topic:save() of
        {ok, Saved} ->
            MQTopic = topic_mq:build(Saved, Member),
            boss_mq:push("new-topics", MQTopic),
            {json, [{topic, Saved}]};
        {error, Errors} ->
            {json, [{errors, Errors}]}
    end.
