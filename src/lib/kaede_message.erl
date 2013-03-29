-module(kaede_message).
-export([add/4, list/3]).

-define(default_sort_order, {orderby, time_stamp}).
-define(with_topic(TopicId), {topic_id, 'equals', TopicId}).
-define(where_date(Op, Origin), {time_stamp, Op, Origin}).

%% kaede_message:add/4
%% adds new message
add(chat, Text, TopicId, MemberId) ->
    Parts = kaede_tags:extract_parts(Text),
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
	     
list(chat, TopicId, all) ->
    Messages = boss_db:find(
		 chatmessage, 
		 [?with_topic(TopicId)],
		 [?default_sort_order]),
    {ok, Messages};

list(chat, TopicId, From) ->
    Messages = boss_db:find(
		 chatmessage, 
		 [?where_date('gt', From), 
		  ?with_topic(TopicId)],
		 [?default_sort_order]),
    {ok, Messages}.
