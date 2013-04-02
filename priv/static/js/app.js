function Topics () {
  var topicTemplate = _.template($("#topic").html()),
      topicList = $(".topics"),
      topicForm = $("form.new_topic"),
      topicText = $('.topic_text', topicForm),

  self = {
    addTopics: function (topics) {
      _.each(topics, function (topic) {
        topicList.prepend(topicTemplate(topic));
        $('.topic').first().data('topic', topic);
      })
    },

    createTopic: function (e) {
      e.preventDefault()

      $.ajax({
        url: e.target.action,
        type: 'POST',
        data: { topic_text: topicText.val() }
      }).success(function (data) {
        topicText.val("")
      }).error(function (jqXHR) {
        alert("Errors: " + jqXHR.responseText)
      })
    },

    poll: function (timestamp) {
      setTimeout(function () {
        $.get("/topic/poll/" + timestamp)
         .success(function (data) {
           self.addTopics(data.topics)
           self.poll(data.timestamp)})
         .error(function(){ self.poll(timestamp); });
      }, 1000)
    },

    fetchStartTopics: function () {
      $.get("/topic")
       .success(function (data) {
        self.addTopics(data.topics)
        self.poll(data.timestamp)
      })
    },

    init: function () {
      topicForm.submit(self.createTopic)
      self.fetchStartTopics()
    }
  }

  self.init()
}

function Messages () {
  var messageTemplate = _.template($("#message").html()),
      topicContentTemplate = _.template($("#topic-content").html()),
  self = {
    addMessages: function (messageBox, messages) {
      var list = $('.messages', messageBox)
      _.each(messages, function (message) {
        list.append(messageTemplate(message))
      })
    },

    createMessage: function (e) {
      e.preventDefault()

      var form = $(this).parents('form'),
          messageText = $('.message_text', form)

      $.ajax({
        url: form.attr("action"),
        type: 'POST',
        data: { text: messageText.val() }
      }).success(function (data) {
        messageText.val("")
      }).error(function (jqXHR) {
        alert("Errors: " + jqXHR.responseText)
      })
    },

    poll: function (messageBox, timestamp) {
      setTimeout(function () {
        $.get(messageBox.data("poll_url") + "/" + timestamp)
         .success(function (data) {
           self.addMessages(messageBox, data.messages)
           self.poll(messageBox, data.timestamp)
        })
      }, 1000)
    },

    initMessaging: function (e) {
      e.preventDefault()

      var topic = $(this).parents('.topic'),
          topicContent = $('.topic-messages');

      // NOTE: Temporary solution to have open only one chat
      // Close the other chats and clear
      topicContent.empty();
      topicContent.append(topicContentTemplate(topic.data('topic')));
      var messageBox = $('.message_box', topicContent);
      $('.new_message button', messageBox).click(self.createMessage);
      
      // Fetch existing messages and run longpolling
      $.get(messageBox.data("index_url"))
       .success(function (data) {
        self.addMessages(messageBox, data.messages)
        self.poll(messageBox, data.timestamp)
      })

      messageBox.show()
    },

    init: function () {
      $('.topics').on("click", "h4 a", self.initMessaging)
    }
  }

  self.init()
}

function Tags () {
  var tagTemplate = _.template($("#tag").html());
  self = {
    addTags: function (container, tags) {
      _.each(tags, function (tag) {
        container.append(tagTemplate(tag));
      });
    },

    init: function () {
      var container = $('.tag-list');
      $.get(container.data("list_url"))
       .done(function(data){ self.addTags(container, data.tags); });
    }
  };
  
  self.init()
}
