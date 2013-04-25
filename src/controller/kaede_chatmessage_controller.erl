-module(kaede_chatmessage_controller, [Req]).
-export([before_/3, index/3, create/3, poll/3]).

before_(_, _, _) ->
    case member_lib:require_login(Req) of
        fail -> {redirect, "/member/login"};
        {ok, Member} -> {ok, Member}
    end.

index('GET', [TopicId], _Member) ->
    {ok, Timestamp, Messages} = kaede_message:list(chat, TopicId),
    {json, [{messages, Messages}, {timestamp, Timestamp}]}.

poll('GET', [TopicId, Ts], _Member) ->
    {ok, Timestamp, Messages} = kaede_message:pull(chat, TopicId, Ts),
    {json, [{timestamp, Timestamp}, {messages, Messages}]}.

create('POST', [TopicId], Member) ->
    Text = Req:post_param("text"),
    case kaede_message:add(chat, Text, TopicId, Member:id()) of
        {ok, Saved} -> {json, [{message, Saved}]};
        {error, Errors} -> {json, [{errors, Errors}]}
    end.
