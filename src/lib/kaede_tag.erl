-module(kaede_tag).
-export([get/1, list/0]).

get(Id) ->
    case boss_db:find(tag, [{id, 'equals', Id}]) of
	[Tag] -> {ok, Tag};
	_     -> {error, not_found}
    end.

list() ->
    Tags = boss_db:find(tag, []),
    {ok, Tags}.

