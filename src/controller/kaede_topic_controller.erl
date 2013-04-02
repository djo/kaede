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
    {json, [{topics, MQTopics}, {timestamp, Timestamp}]};

index('GET', ["tag", TagId], Member) ->
    Links = boss_db:find(topic_tag, [{tag_id, 'equals', TagId}]),
    TopicIds = [Link:topic_id() || Link <- Links],
    Topics = boss_db:find(topic, [{id, 'in', TopicIds}]),
    MQTopics = lists:map(fun(Topic) -> topic_mq:build(Topic, Member) end, Topics),
    {json, [{topics, MQTopics}]}.

poll('GET', [Timestamp], Member) ->
    {ok, NewTimestamp, Topics} = boss_mq:pull("new-topics",
        list_to_integer(Timestamp)),
    {json, [{timestamp, NewTimestamp}, {topics, Topics}]}.

create('POST', [], Member) ->
    TopicText = Req:post_param("topic_text"),
    Topic = topic:new(id, TopicText, Member:id()),

    case Topic:save() of
        {ok, Saved} ->
            MQTopic = topic_mq:build(Saved, Member),
            boss_mq:push("new-topics", MQTopic),
            Tags = proplists:get_value(tags, kaede_tag:extract_parts(TopicText)),
            LinkResults = [kaede_tag:link(Saved:id(), Tag) || Tag <- Tags],
            {json, [{topic, Saved}]};
        {error, Errors} ->
            {json, [{errors, Errors}]}
    end.
