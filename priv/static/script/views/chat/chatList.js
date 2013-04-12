define([
    'Backbone',
    'views/chat/chatListItem',
    'text!templates/chat/chatList.html'
], function (Backbone, ChatListItemView, ChatListTemplate) {
    var ChatListView = Backbone.View.extend({
	tagName: 'div',
	
	initialize: function (args) {
	    this.collection.on('add remove reset change', this.render, this);
	},

	render: function () {
	    var self = this;
	    self.$el.empty();
	    
	    var compiledTemplate = _.template(ChatListTemplate, {});
	    self.$el.html(compiledTemplate);
            var container = self.$('.chat-list');
            
	    self.collection.each(function (topic, index) {
		var chatListItemView = new ChatListItemView({ model: topic });
		var row = chatListItemView.render().$el;
		container.append(row);
	    }, self);
            
	    return self;
	},
    });
    return ChatListView;
}); 
