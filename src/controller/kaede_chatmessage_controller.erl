-module(kaede_chatmessage_controller, [Req]).
-compile(export_all).

create('POST', []) ->
    MemberId = Req:post_param("member_id"),
    Message = Req:post_param("message"),
    TopicId = Req:post_param("topic_id"),
    ChatMessage = kaede_message:add(chat, Message, TopicId, MemberId),
    {json, [{message, ChatMessage}]}.
    
