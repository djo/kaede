-module(kaede_chatmessage_controller, [Req]).
-compile(export_all).

create('POST', []) ->
    MemberId = Req:post_param("member_id"),
    Message = Req:post_param("message"),
    TopicId = Req:post_param("topic_id"),
    ChatMessage = kaede_message:add(chat, Message, TopicId, MemberId),
    {json, [{message, ChatMessage}]}.
    
list('GET', [TopicId]) ->
    {ok, RawMessages} = kaede_message:list(chat, TopicId, all),
    Messages = lists:map(fun map_message/1, RawMessages),
    {json, [{messages, Messages}]}.

map_message(Message) ->
    [{id, Message:id()},
     {text, Message:text()},
     {member_id, Message:member_id()}].
			
