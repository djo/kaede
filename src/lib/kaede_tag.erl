-module(kaede_tag).
-export([create/1, get/1, list/0]).
-export([init_default/0]).

%% tag_lib:init_default
%% заполняет таблицу тестовыми тегами. только для отладки
init_default() ->
    TagNames = ["общение", 
		"события", 
		"авто", 
		"бизнес", 
		"любовь", 
		"личное" ],
    lists:map(fun create/1, 
	      TagNames).

create(Text) ->
    Tag = tag:new(id, utf8_decode(Text)),
    Tag:save().

get(Id) ->
    case boss_db:find(tag, [{id, 'equals', Id}]) of
	[Tag] -> {ok, Tag};
	_     -> {error, not_found}
    end.

list() ->
    Tags = boss_db:find(tag, []),
    {ok, Tags}.

utf8_decode(Text) ->
    binary:bin_to_list(
      unicode:characters_to_binary(
	Text)).

