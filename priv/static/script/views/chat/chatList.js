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

        activeRequest: undefined,
        activeTimeout: undefined,
        pollingInterval: 1,
        timestamp: "0",
        childMessages: {},

        fetch: function(topic_id, fn_continue){
            var self = this;
            var url = "/chatmessage/index/" + topic_id;
            if (fn_continue)
                $.get(url)
                 .done(function(data){
                     fn_continue(data.messages);
                 });
        },

        run: function () {
            var self = this;

            if (self.activeRequest != undefined)
                self.activeRequest.abort()

            self.activeTimeout = setTimeout(function () {
                var ids = [];
                for (var id in self.childMessages)
                    ids.push(id);

                if (_.size(ids) <= 0)
                    self.run();
                else{
                    var url = "/chatmessage/pull/" 
                        + self.timestamp 
                        + _.reduce(ids, function(acc, it){
                            return acc + "/" + it}, "");

                    self.activeRequest = $.ajax({
                        type: "GET",
                        url: url,
                        cache: false,
                        success: function (data) {
                            self.addMessages(data.messages);
                            self.timestamp = data.timestamp;
                            self.run();
                        },
                        error: function (xhr) {
                            self.run();
                        }
                    });
                }
            }, 1000*self.pollingInterval)
        },
        
	render: function () {
	    var self = this;
	    self.$el.empty();
	    
	    var compiledTemplate = _.template(ChatListTemplate, {});
	    self.$el.html(compiledTemplate);
            var container = self.$('.chat-list');
            
	    self.collection.each(function (topic, index) {
                var topic_id = topic.get("topic_id")
                if (!(topic_id in self.childMessages)){
                    self.fetch(topic_id, function(fetched){
                        var fetchedModels = _.map(fetched, self.create_msg);
                        var newChatItemView = new ChatListItemView({ 
                            model: topic, 
                            collection: new Backbone.Collection(fetchedModels) });
                        self.childMessages[topic_id] = newChatItemView;
                        self.render_chat(container, newChatItemView);
                        if (self.activeRequest != undefined)
                            self.activeRequest.abort()
                    });
                }
                else{
                    var child = self.childMessages[topic_id];
                    self.render_chat(container, child);
                }
	    }, self);
            
	    return self;
	},

        create_msg: function(data){
            return new Backbone.Model(data);
        },

        render_chat: function(container, child){
	    var row = child.render().$el;
	    container.append(row);
        },

        addMessages: function(messages){
            var self = this;
            _.each(messages, function(m){
                self.childMessages[m.topic_id].collection.add(self.create_msg(m));
            });
        },
        
    });
    return ChatListView;
}); 
