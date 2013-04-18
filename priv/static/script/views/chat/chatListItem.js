define([
    'Backbone',
    'text!templates/chat/chatListItem.html',
    'text!templates/chat/message.html',
    'views/topic/topicListItem'
], function (Backbone, ChatListItemTemplate, MessageTemplate, TopicListItemView) {
    var ChatListItemView = Backbone.View.extend({
	tagName: 'div',
	className: 'chat',
        
	initialize: function (args) {
	    this.collection.on('add remove reset change', this.render, this);
	},
        
	render: function () {
	    var self = this;
            var headTemplate = _.template(ChatListItemTemplate, 
                                          self.model.toJSON());
	    self.$el.html(headTemplate);

            var msg_container = self.$('.messages');
            self.collection.each(function (message) {
                var msgTemplate = _.template(MessageTemplate, message.toJSON());
                msg_container.append(msgTemplate);
            });
	    return self;
	}
    });
    return ChatListItemView;
}); 
