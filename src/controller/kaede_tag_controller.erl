-module(kaede_tag_controller, [Req]).
-compile(export_all).

id('GET', [Id]) ->
    case boss_db:find(tag, [{id, 'equals', Id}]) of
	[Tag] -> {json, [{tag, map_tag(Tag)}]};
	_     -> not_found
    end.


list('GET', []) ->
    Tags = lists:map(fun map_tag/1,
		     boss_db:find(tag, [])),
    {json, [{tags, Tags}]}.


map_tag(Tag) ->
    Id = Tag:id(),
    Text = Tag:text(),
    [{id, Id},
     {tag, Text}].
