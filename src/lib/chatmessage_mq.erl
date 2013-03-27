-module(chatmessage_mq).
-export([build/2, channel_name/1]).

% Builds the Topic structure which will be used in the message queue
build(Message, Member) ->
    [{text, Message:text()},
     {member_name, Member:name()}].

channel_name(TopicId) ->
    "new-messages" ++ TopicId.
