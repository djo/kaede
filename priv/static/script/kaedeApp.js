define([
  'collections/topicList',
  'collections/tagList',
  'views/topic/topicList',
  'views/tag/tagList',
  'views/chat/chat'
], function (
  TopicCollection, 
  TagCollection, 
  TopicListView,
  TagListView,
  Chat) {
  var KaedeApp = {
    initialize: function () {
      var self = this;

      self.topics = self.initCollection(TopicCollection, TopicListView, $('.topics'));
      self.tags = self.initCollection(TagCollection, TagListView,  $('.tags'));
      self.chat = new Chat({el: $('.chats')});
      self.topics.on('chat:open', self.openChat, self);
      self.topics.run();
      self.tags.run();

      return self;
    },

    initCollection: function(Collection, View, target, opt){
      var collection = new Collection();
      var params = { el: target, collection: collection };
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
