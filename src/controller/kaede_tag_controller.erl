-module(kaede_tag_controller, [Req]).
-export([get/2, list/2]).

get('GET', [Id]) ->
    case kaede_tag:get(Id) of
	{ok, Tag} -> {json, [{tag, map_tag(Tag)}]};
	_   -> not_found
    end.


list('GET', []) ->
    {ok, RawTags} = kaede_tag:list(),
    Tags = lists:map(fun map_tag/1, RawTags),
    {json, [{tags, Tags}]}.

map_tag(Tag) ->
    Id = Tag:id(),
    Text = Tag:text(),
    [{id, Id},
     {text, Text}].
