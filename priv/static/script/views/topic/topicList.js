define([
  'Backbone',
  'models/topic',
  'views/topic/topicListItem',
  'text!templates/topic/topicList.html'
], function (Backbone, Topic, TopicListItemView, TopicListTemplate) {
  var TopicListView = Backbone.View.extend({
    tagName: 'div',

    events: {
      'click .add-topic': 'createTopic',
      'keypress .topic-text': 'processKeypress'
    },

    pollingInterval: 50,

    initialize: function (args) {
      this.collection.on('add remove reset change', this.render, this);
      var self = this;
      self.$el.empty();
      var compiledTemplate = _.template(TopicListTemplate, {});
      self.$el.html(compiledTemplate);
      self.topicTextInput = self.$('.topic-text');
    },

    run: function(){
      var self = this;
      self.collection.fetch();
      setInterval(function() {
        self.collection.fetch();
      }, 1000 * self.pollingInterval);
    },

    render: function () {
      var self = this;
      var container = self.$('.topic-list');
      container.empty();

      self.collection.each(function (topic, index) {
        var topicListItemView = new TopicListItemView({ model: topic });
        topicListItemView.on('chat:open', self.openChat, self);
        var row = topicListItemView.render().$el;
        container.prepend(row);
      }, self);

      self.$('.no-topics').toggle(self.collection.length == 0);            
      return self;
    },

    createTopic: function(){
      var self = this;
      var topic = new Topic();

      var addTopic = function (saved) {
        self.collection.add(saved);
        self.topicTextInput.val('');
      };

      topic.save({ topic_text: self.topicTextInput.val() }, { success: addTopic, wait: true });
    },

    openChat: function(topicItemView) {
      this.trigger('chat:open', topicItemView.model);
    },

    processKeypress: function(evt) {
      if (evt.keyCode != 13) return;
      this.createTopic();
    }
  });

  return TopicListView;
}); 
