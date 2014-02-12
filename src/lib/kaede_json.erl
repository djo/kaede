-module(kaede_json).
-export([decode/1, get_value/2, get_string/2]).

decode(Data) -> mochijson2:decode(Data).

get_value(Prop, {struct, Json}) ->
    BinProp = binary:list_to_bin(Prop),
    proplists:get_value(BinProp, Json).

get_string(Prop, Data) ->
    binary:bin_to_list(get_value(Prop, Data)).
