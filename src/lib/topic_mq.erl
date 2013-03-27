-module(topic_mq).
-export([build/2]).

% Builds the Topic structure which will be used in the message queue
build(Topic, Member) ->
    [{topic_id, Topic:id()},
     {topic_text, Topic:topic_text()},
     {member_name, Member:name()}].
