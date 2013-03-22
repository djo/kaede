-module(kaede_message).
-export([add/4, list/3]).

-define(token_stops, " #@").
-define(default_sort_order, {orderby, time_stamp}).
-define(with_topic(TopicId), {topic_id, 'equals', TopicId}).
-define(where_date(Op, Origin), {time_stamp, Op, Origin}).

%% kaede_message:add/4
%% добавляет новое сообщение в чат
add(chat, Text, TopicId, MemberId) ->
    Parts = extract_parts(Text),
    _Tags = proplists:get_value(tags, Parts),
    Result = boss_db:transaction(
	       fun () ->
		       Msg = chatmessage:new(id, Text, TopicId, MemberId, now()),
		       %% TODO: add links to tags, notify
		       %% TODO: add links to users, notify
		       Msg:save()
	       end),
    case Result of
	{atomic, {ok, Saved}} -> 
	    {ok, Saved};
	_ -> 
	    {error, Result}
    end.
	     
list(chat, TopicId, all) ->
    Messages = boss_db:find(
		 chatmessage, 
		 [?with_topic(TopicId)],
		 [?default_sort_order]),
    {ok, Messages};

list(chat, TopicId, From) ->
    Messages = boss_db:find(
		 chatmessage, 
		 [?where_date('gt', From), 
		  ?with_topic(TopicId)],
		 [?default_sort_order]),
    {ok, Messages}.

	     

%% извлекает из строки теги вида #тег @пользователь
extract_parts(Text) ->
    Parts = extract_parts([], Text),
    {Tags, Users} = 
	lists:foldl(
	  fun ({tag,  T}, {At, Au}) -> {[T|At], Au};
	      ({user, U}, {At, Au}) -> {At, [U|Au]};
	      (_, Acc) -> Acc 
	  end,
	  {[], []},
	  Parts),
    [{tags, Tags}, {users, Users}].

extract_parts(Acc, []) ->
    lists:reverse(Acc);

extract_parts(Acc, [Char|Rest]) ->
    {NewAcc, NewRest} = 
	case Char of
	    ($#) -> {Token, R} = read_to(?token_stops, [], Rest),
		    {[{tag, Token}|Acc], R};
	    ($@) -> {Token, R} = read_to(?token_stops, [], Rest),
		    {[{user, Token}|Acc], R};
	    _    -> {Acc, Rest}
	end,
    extract_parts(NewAcc, NewRest).
	     
%% читает символы до первого стоп-символа
read_to(_Stops, Acc, []) -> 
    {lists:reverse(Acc), []};

read_to(Stops, Acc, [Char|Rest]) -> 
    case lists:any(fun (Stop) -> Stop =:= Char end, Stops) of
	true -> {lists:reverse(Acc), [Char|Rest]};
	false -> read_to(Stops, [Char|Acc], Rest)
    end.

