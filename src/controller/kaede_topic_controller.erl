-module(kaede_topic_controller, [Req]).
-export([before_/3, pull/3, create/3]).

before_(_, _, _) ->
    case member_lib:require_login(Req) of
        fail -> {redirect, "/member/login"};
        {ok, Member} -> {ok, Member}
    end.

pull('GET', [Timestamp], Member) ->
    {ok, NewTimestamp, Topics} = boss_mq:pull("new-topics",
        list_to_integer(Timestamp)),
    {json, [{timestamp, NewTimestamp}, {topics, Topics}]}.

create('POST', [], Member) ->
    TopicText = Req:post_param("topic_text"),
    Topic = topic:new(id, TopicText),
    case Topic:save() of
        {ok, Saved} ->
            {json, [{topic, Saved}]};
        {error, Errors} ->
            {json, [{errors, Errors}]}
    end.
