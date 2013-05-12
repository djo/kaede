define([
  'Backbone',
  'text!templates/chat/chat.html',
  'text!templates/chat/message.html',
  'text!templates/chat/member.html',
  'views/topic/topicListItem'
], function (Backbone, ChatTemplate, MessageTemplate, MemberTemplate, TopicListItemView) {
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
      'click .add-message': 'createMessage',
      'keypress .message-text': 'processKeypress'
    },

    fetch: function(fn_continue) {
      var self = this;
      var url = "/chatmessage/index/" + self.topic_id;
      if (fn_continue)
        $.get(url).done(function(data) {
          self.timestamp = data.timestamp;
          fn_continue(data.messages);
        });
    },

    setTopic: function(topic) {
      var self = this;
      self.stop();
      self.messages = [];
      self.topic_id = topic.get("topic_id");
      self.model = topic;
       
      var headTemplate = _.template(ChatTemplate, self.model.toJSON());

      self.$el.html(headTemplate);
      self.messageTextInput = self.$('.message-text');
      
      self.run();
    },

    stop: function() {
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
        self.poll();
      });
    },

    poll: function () {
      var self = this;

      self.activeTimeout = setTimeout(function () {
        var url = "/chatmessage/poll" + "/" + self.topic_id + "/" + self.timestamp;

        self.activeRequest = $.ajax({
          type: "GET",
          url: url,
          cache: false,
          timeout: 20000,
          success: function (data) {
            self.addMessages(data.messages);
            self.timestamp = data.timestamp;
            self.poll();
          },
          error: function (xhr) {
            if (xhr.statusText !== "abort") {
              self.activeRequest = undefined;
              self.poll();
            }
          }
        });
      }, 1000 * self.pollingInterval)
    },

    render: function () {
      var self = this;

      var msg_container = self.$('.messages');
      msg_container.empty();
      _.reduce(
        self.messages, 
        function (prev_user, message) {
          if (prev_user != message.member_id){
            var memTemplate = _.template(MemberTemplate, message);
            msg_container.append(memTemplate);
          }
          var msgTemplate = _.template(MessageTemplate, message);
          msg_container.append(msgTemplate);
          return message.member_id;
        },
        null);

      return self;
    },

    addMessages: function(messages){
      var self = this;
      _.each(messages, function(m) { self.messages.push(m); });
      self.render();
    },

    createMessage: function(){
      var self = this;
      var url = "/chatmessage/create/" + self.topic_id;
      var data = { text: self.messageTextInput.val() };

      $.ajax({
        url: url,
        type: 'POST',
        data: data
      }).success(function (data) {
        self.messageTextInput.val("")
      }).error(function (jqXHR) {
        alert("Errors: " + jqXHR.responseText)
      })
    },
    
    processKeypress: function(evt) {
        if (evt.keyCode != 13) return;
        this.createMessage();
      }
  });

  return Chat;
}); 
