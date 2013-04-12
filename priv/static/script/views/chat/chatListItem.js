define([
    'Backbone',
    'text!templates/chat/chatListItem.html',
    'views/topic/topicListItem'
], function (Backbone, ChatListItemTemplate, TopicListItemView) {
    var ChatListItemView = Backbone.View.extend({
	tagName: 'div',
	className: 'chat',
        
	render: function () {
	    var self = this;
            var headTemplate = new TopicListItemView({ model: self.model });
	    self.$el.html(headTemplate.render().$el);
	    return self;
	}
    });
    return ChatListItemView;
}); 
