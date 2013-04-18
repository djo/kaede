-module(mq_listener).
-export([pull/2]).

pull(Channels, Since) ->
    Self = self(),
    Pids = [spawn(fun () -> pull_single(Ch, Since, Self) end)
            || Ch <- Channels],
    receive
        {From, {ok, Ts, Messages}} ->
            [exit(Pid, normal) || Pid <- Pids, Pid =/= From],
            {ok, Ts, Messages};
        {From, Err} -> Err
    end.

pull_single(Channel, Since, Owner) ->
    Result = boss_mq:pull(Channel, Since),
    Owner ! {self(), Result}.
    
