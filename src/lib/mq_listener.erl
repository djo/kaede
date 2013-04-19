-module(mq_listener).
-export([pull/2]).

pull(Channels, Since) ->
    Self = self(),
    Pids = [spawn(fun () -> pull_single(Ch, Since, Self) end)
            || Ch <- Channels],
    collect(Pids).

collect(Pids) ->
    Received = collect(Pids, [], infinity),
    {Messages, Ts} = lists:foldl(fun (Acc, {ok, Ts, Messages}) -> 
                                   {[Messages|Acc], Ts}  
                           end, 
                           {[], 0},
                           Received),
    {ok, Ts, Messages}.

%% grabs messages from listened channels
collect(Pids, Acc, Timeout) ->
    receive
        {From, Result={ok,_,_}} ->
            [exit(Pid, kill) || Pid <- Pids, Pid =/= From],
            collect([], [Result|Acc], 0);
        Other -> error_logger:warning_msg(
                   "~p receives ~p~n", 
                   [?MODULE, Other])
    after 
        Timeout -> Acc
    end.

pull_single(Channel, Since, Owner) ->
    Result = boss_mq:pull(Channel, Since),
    Owner ! {self(), Result}.
    
