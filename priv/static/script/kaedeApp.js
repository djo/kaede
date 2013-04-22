define([
    'collections/topicList',
    'collections/tagList',
    'collections/chatList',
    'views/topic/topicList',
    'views/tag/tagList',
    'views/chat/chat'
], function (
    TopicCollection, 
    TagCollection, 
    ChatCollection, 
    TopicListView,
    TagListView,
    Chat) {
    var KaedeApp = {
	initialize: function () {
	    var self = this;

            self.topics = self.init_collection(
                TopicCollection, 
                TopicListView, 
                $('.topics'));

            self.tags = self.init_collection(
                TagCollection, 
                TagListView, 
                $('.tags'));

            self.chat = new Chat({el: $('.chats')});
            self.topics.on('chat:open', self.openChat, self);

            self.topics.run();
            self.tags.run();

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
        },

        openChat: function(topic) {
            var self = this;
            self.chat.setTopic(topic);
        }
    };

    return KaedeApp;
});
