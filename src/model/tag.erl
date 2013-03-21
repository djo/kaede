-module(tag, [Id, Text]).
-compile(export_all).

validation_tests() ->
    [{fun () -> length(Text) > 0 end,
     "Tag is empty"},

     {fun () -> length(Text) =< 100 end,
     "Tag is too long"}].
