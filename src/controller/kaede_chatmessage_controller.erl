-module(kaede_chatmessage_controller, [Req]).
-export([before_/3, index/3, create/3, poll/3]).

before_(_, _, _) ->
    case member_lib:require_login(Req) of
        fail -> {redirect, "/member/login"};
        {ok, Member} -> {ok, Member}
    end.

index('GET', [TopicId], Member) ->
    Messages = boss_db:find(chatmessage, [{topic_id, 'equals', TopicId}]),
    MQMessages = lists:map(fun(Message) -> chatmessage_mq:build(Message, Member) end, Messages),
    ChannelName = chatmessage_mq:channel_name(TopicId),
    Timestamp = boss_mq:now(ChannelName),
    {json, [{messages, MQMessages}, {timestamp, Timestamp}]}.

poll('GET', [TopicId, Timestamp], Member) ->
    ChannelName = chatmessage_mq:channel_name(TopicId),
    {ok, NewTimestamp, Messages} = boss_mq:pull(ChannelName,
        list_to_integer(Timestamp)),
    {json, [{timestamp, NewTimestamp}, {messages, Messages}]}.

create('POST', [TopicId], Member) ->
    Text = Req:post_param("text"),
    Message = chatmessage:new(id, Text, TopicId, Member:id(), now()),
    case Message:save() of
        {ok, Saved} -> {json, [{message, Saved}]};
        {error, Errors} -> {json, [{errors, Errors}]}
    end.
