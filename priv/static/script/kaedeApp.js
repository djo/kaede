define([
    'collections/topicList',
    'collections/tagList',
    'collections/chatList',
    'views/topic/topicList',
    'views/tag/tagList',
    'views/chat/chatList'
], function (
    TopicCollection, 
    TagCollection, 
    ChatCollection, 
    TopicListView,
    TagListView,
    ChatListView) {
    var KaedeApp = {
	initialize: function () {
	    var self = this;

            var chats = self.init_collection(
                ChatCollection, 
                ChatListView, 
                $('.chats'));

            var topics = self.init_collection(
                TopicCollection, 
                TopicListView, 
                $('.topics'),
                { chats: chats.collection });

            var tags = self.init_collection(
                TagCollection, 
                TagListView, 
                $('.tags'));

            topics.run();
            tags.run();
            chats.run();

	    return self;
	},

        init_collection: function(Collection, View, target, opt){
            var collection = new Collection();
            var params = {
                el: target, 
		collection: collection };

            var view = new View(params);
            $.extend(view, opt);
            return view;
        }
    };

    return KaedeApp;
});
