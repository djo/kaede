-module(kaede_message).
-export([add/4, list/2, pull/3, map_message/1]).

-define(default_sort_order, {orderby, time_stamp}).
-define(with_topic(TopicId), {topic_id, 'equals', TopicId}).
-define(where_date(Op, Origin), {time_stamp, Op, Origin}).

%% kaede_message:add/4
%% adds new message
add(chat, Text, TopicId, MemberId) ->
    Parts = kaede_tag:extract_parts(Text),
    _Tags = proplists:get_value(tags, Parts),
    Result = boss_db:transaction(
	       fun () ->
		       Msg = chatmessage:new(id, Text, TopicId, MemberId, now()),
		       %% TODO: add links to tags, notify
		       %% TODO: add links to users, notify
		       Msg:save()
	       end),
    case Result of
	{atomic, {ok, Saved}} -> 
	    {ok, Saved};
	_ -> 
	    {error, Result}
    end.
	     
list(chat, TopicId) ->
    Channel = chatmessage_mq:channel_name(TopicId),
    Ts = boss_mq:now(Channel),
    Messages = boss_db:find(
		 chatmessage, 
		 [?with_topic(TopicId)],
		 [?default_sort_order]),
    {ok, Ts, lists:map(fun map_message/1, Messages)}.

pull(chat, TopicId, From) ->
    Channel = chatmessage_mq:channel_name(TopicId),
    {ok, Ts, Messages} = boss_mq:pull(Channel, list_to_integer(From)),
    {ok, Ts, lists:map(fun map_message/1, Messages)}.

map_message(Message) ->
    [Member] = boss_db:find(member, [id, 'equals', Message:member_id()]),
    [{text, Message:text()},
     {member_id, Member:id()},
     {member_name, Member:name()},
     {topic_id, Message:topic_id()}].
