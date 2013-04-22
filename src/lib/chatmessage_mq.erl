-module(chatmessage_mq).
-export([build/2, channel_name/1]).

% Builds the Topic structure which will be used in the message queue
build(Message, Member) ->
    [{text, Message:text()},
     {member_name, Member:name()},
     {topic_id, Message:topic_id()}].

channel_name(TopicId) ->
    "topic." ++ TopicId.
