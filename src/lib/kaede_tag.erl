-module(tag_lib).
-export([create_tag/1]).
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
    lists:map(fun create_tag/1, 
	      TagNames).

create_tag(Text) ->
    Tag = tag:new(id, utf8_decode(Text)),
    Tag:save().

utf8_decode(Text) ->
    binary:bin_to_list(
      unicode:characters_to_binary(
	Text)).
