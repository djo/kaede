-module(kaede_topic_controller, [Req]).
-export([before_/3, index/3]).

before_(_, _, _) ->
    case kaede_auth:require_login(Req) of
        fail -> {redirect, "/member/login"};
        {ok, Member} -> {ok, Member}
    end.

index('GET', [], _Member) ->
    {ok, Topics} = kaede_topic:list(),
    {json, [{topics, Topics}]};

index('GET', ["tag", TagId], _Member) ->
    {ok, Topics} = kaede_topic:list(TagId),
    {json, [{topics, Topics}]};

index('POST', [], Member) ->
    Json = kaede_json:decode(Req:request_body()),
    Text = kaede_json:get_string("topic_text", Json),
    case kaede_topic:add(Text, Member:id()) of
        {ok, Topic}     -> {json, Topic};
        {error, Errors} -> {json, [{errors, Errors}]}
    end.
