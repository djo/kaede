define([
    'Backbone',
    'text!templates/topic/topicListItem.html'
], function (Backbone, TopicListItemTemplate) {
  var TopicListItemView = Backbone.View.extend({
    tagName: 'div',
    className: 'topic-item',

    events: {
      'click h4 a': 'openChat'
    },

    render: function () {
      var self = this;
      var compiledTemplate = _.template(TopicListItemTemplate, self.model.toJSON());
      self.$el.html(compiledTemplate);
      return self;
    },

    openChat: function (e) {
      e.preventDefault();
      this.trigger('chat:open', this);
    }
  });

  return TopicListItemView;
}); 
