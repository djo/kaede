-module(kaede_topic).
-export([add/2, list/0, list/1, map_topic/1]).

-define(default_sort_order, {orderby, time_stamp}).
-define(with_topic(TopicId), {topic_id, 'equals', TopicId}).
-define(where_date(Op, Origin), {time_stamp, Op, Origin}).

add(Text, MemberId) ->
    Result = boss_db:transaction(
        fun () ->
            Topic = topic:new(id, Text, MemberId),
            {ok, Saved} = Topic:save(),
            Parts = kaede_tag:extract_parts(Text),
            Tags = proplists:get_value(tags, Parts),
            [kaede_tag:link(Saved:id(), Tag) || Tag <- Tags], {ok, map_topic(Saved)}
        end),
    case Result of
        {atomic, {ok, Saved}} -> {ok, Saved};
        _ -> {error, Result}
    end.

list() ->
    Topics = boss_db:find(topic, []),
    {ok, lists:map(fun map_topic/1, Topics)}.

list(TagId) ->
    Links = boss_db:find(topic_tag, [{tag_id, 'equals', TagId}]),
    TopicIds = [Link:topic_id() || Link <- Links],
    Topics = boss_db:find(topic, [{id, 'in', TopicIds}]),
    {ok, lists:map(fun map_topic/1, Topics)}.

map_topic(Topic) ->
    [Member] = boss_db:find(member, [id, 'equals', Topic:member_id()]),
    [{topic, [{topic_id, Topic:id()}, {topic_text, Topic:topic_text()}, {member_name, Member:name()}]}].
