-module(kaede_tag).
-export([get/1, list/0, link/2]).
-export([extract_parts/1]).
-define(token_stops, " #@").

get(Id) ->
    case boss_db:find(tag, [{id, 'equals', Id}]) of
        [Tag] -> {ok, Tag};
        _ -> {error, not_found}
    end.

list() ->
    Tags = boss_db:find(tag, []),
    {ok, Tags}.

%% Links topic with tag, creates a new tag if specified text not found
link(TopicId, TagText) ->
    Result = boss_db:transaction(
        fun () ->
            Tag = find(TagText),
            Link = topic_tag:new(id, TopicId, Tag:id()),
            {ok, SavedLink} = Link:save(), SavedLink
        end),
    case Result of
        {atomic, Link} -> {ok, Link};
        Error -> {error, Error}
    end.

find(TagText) ->
    case boss_db:find(tag, [text, 'equals', TagText]) of
        [Tag] -> Tag;
        _ -> undefined
    end.

%% Extracts parts from a string, "@user_name #tag_name"
extract_parts(Text) ->
    Parts = extract_parts([], Text),
    {Tags, Users} = 
        lists:foldl(
            fun ({tag,  T}, {At, Au}) -> {[T|At], Au};
                ({user, U}, {At, Au}) -> {At, [U|Au]};
                (_, Acc) -> Acc 
            end,
            {[], []}, Parts),
    [{tags, Tags}, {users, Users}].
extract_parts(Acc, []) ->
    lists:reverse(Acc);
extract_parts(Acc, [Char|Rest]) ->
    {NewAcc, NewRest} = 
    case Char of
        ($#) ->
            {Token, R} = read_to(?token_stops, [], Rest),
		    {[{tag, Token}|Acc], R};
        ($@) ->
            {Token, R} = read_to(?token_stops, [], Rest),
            {[{user, Token}|Acc], R};
        _ ->
            {Acc, Rest}
	end,
    extract_parts(NewAcc, NewRest).

%% Reads input until stopchar
read_to(_Stops, Acc, []) -> 
    {lists:reverse(Acc), []};
read_to(Stops, Acc, [Char|Rest]) ->
    case lists:any(fun (Stop) -> Stop =:= Char end, Stops) of
        true -> {lists:reverse(Acc), [Char|Rest]};
        false -> read_to(Stops, [Char|Acc], Rest)
    end.
