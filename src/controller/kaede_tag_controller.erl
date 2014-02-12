-module(kaede_tag_controller, [Req]).
-export([before_/3, index/3, show/3]).

before_(_, _, _) ->
    case kaede_auth:require_login(Req) of
        fail -> {redirect, "/member/login"};
        {ok, Member} -> {ok, Member}
    end.

index('GET', [], Member) ->
    {ok, RawTags} = kaede_tag:list(),
    Tags = lists:map(fun map_tag/1, RawTags),
    {json, [{tags, Tags}]}.

show('GET', [Id], Member) ->
    case kaede_tag:get(Id) of
        {ok, Tag} -> {json, map_tag(Tag)};
        _  -> not_found
    end.

map_tag(Tag) ->
    Id = Tag:id(),
    Text = Tag:text(),
    [{tag, [{id, Id}, {text, Text}]}].
