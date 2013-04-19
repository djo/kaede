define([
    'Backbone',
    'text!templates/chat/chat.html',
    'text!templates/chat/message.html',
    'views/topic/topicListItem'
], function (Backbone, ChatTemplate, MessageTemplate, TopicListItemView) {
    var Chat = Backbone.View.extend({
	tagName: 'div',
	className: 'chat',
        
        activeRequest: undefined,
        activeTimeout: undefined,
        pollingInterval: 1,
        timestamp: 0,
        topic_id: undefined,
        messages: [],

	events: {
	    'click .add-message': 'createMessage'
	},

        fetch: function(fn_continue){
            var self = this;
            var url = "/chatmessage/index/" + self.topic_id;
            if (fn_continue)
                $.get(url)
                .done(function(data){
                    self.timestamp = data.timestamp;
                    fn_continue(data.messages);
                });
        },

        set_topic: function(topic){
            var self = this;
            self.stop();
            //self.$el.empty();
            self.messages = [];
            self.topic_id = topic.get("topic_id");
            self.model = topic;
            self.run();
        },

        stop: function(){
            var self = this;
            if (self.activeTimeout != undefined)
                clearTimeout(self.activeTimeout);

            if (self.activeRequest != undefined)
                self.activeRequest.abort()
        },

        run: function(){
            var self = this;
            self.fetch(function(messages){
                self.addMessages(messages);
                self.render();
                
                self.poll();
            });
        },

        poll: function () {
            var self = this;

            self.activeTimeout = setTimeout(function () {
                var url = "/chatmessage/poll" 
                    + "/" + self.topic_id
                    + "/" + self.timestamp;

                self.activeRequest = $
                    .get(url)
                    .done(function (data) {
                        self.addMessages(data.messages);
                        self.timestamp = data.timestamp;
                        self.poll();
                    });
            }, 1000*self.pollingInterval)
        },

	render: function () {
	    var self = this;
            var headTemplate = _.template(ChatTemplate, 
                                          self.model.toJSON());
	    self.$el.html(headTemplate);
            self.messageTextInput = self.$('.message-text');

            var msg_container = self.$('.messages');
            _.each(self.messages, function (message) {
                var msgTemplate = _.template(MessageTemplate, message);
                msg_container.append(msgTemplate);
            });
	    return self;
	},

        addMessages: function(messages){
            var self = this;
            _.each(messages, function(m){
                self.messages.push(m);
            });
            self.render();
        },

	createMessage: function(){
	    var self = this;
            var message_text = self.messageTextInput.val();
            alert("TODO: call server for: " + message_text);
	},

    });
    return Chat;
}); 
