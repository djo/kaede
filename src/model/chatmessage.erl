-module(chatmessage, [Id, Text, TopicId, MemberId, TimeStamp]).
-compile(export_all).
-belongs_to(topic).
-belongs_to(member).
