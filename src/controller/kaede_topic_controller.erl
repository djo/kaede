-module(kaede_topic_controller, [Req]).
-export([before_/3, index/3, create/3]).

before_(_, _, _) ->
    case member_lib:require_login(Req) of
        fail -> {redirect, "/member/login"};
        {ok, Member} -> {ok, Member}
    end.

index('GET', [], Member) ->
    Topics = boss_db:find(topic, []),
    MQTopics = lists:map(fun(Topic) -> map_topic(Topic, Member) end, Topics),
    {json, [{topics, MQTopics}]};

index('GET', ["tag", TagId], Member) ->
    Links = boss_db:find(topic_tag, [{tag_id, 'equals', TagId}]),
    TopicIds = [Link:topic_id() || Link <- Links],
    Topics = boss_db:find(topic, [{id, 'in', TopicIds}]),
    MQTopics = lists:map(fun(Topic) -> map_topic(Topic, Member) end, Topics),
    {json, [{topics, MQTopics}]}.

create('POST', [], Member) ->
    TopicText = Req:post_param("topic_text"),
    Topic = topic:new(id, TopicText, Member:id()),
    case Topic:save() of
        {ok, Saved} ->
            MQTopic = map_topic(Saved, Member),
            Tags = proplists:get_value(tags, kaede_tag:extract_parts(TopicText)),
            LinkResults = [kaede_tag:link(Saved:id(), Tag) || Tag <- Tags],
            {json, [{topic, MQTopic}]};
        {error, Errors} ->
            {json, [{errors, Errors}]}
    end.

map_topic(Topic, Member) ->
    [{topic_id, Topic:id()},
     {topic_text, Topic:topic_text()},
     {member_name, Member:name()}].
