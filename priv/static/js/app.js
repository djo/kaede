function Topics () {
  var topicTemplate = _.template($("#topic").html()),
      topicList = $(".topics"),
      topicForm = $("form.new_topic"),
      topicText = $('.topic_text', topicForm),

  self = {
    addTopics: function (topics) {
      _.each(topics, function (topic) {
        topicList.prepend(topicTemplate(topic))
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
           self.poll(data.timestamp)
        })
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

  self = {
    addMessages: function (messageBox, messages) {
      var list = $('.messages', messageBox)
      _.each(messages, function (message) {
        list.prepend(messageTemplate(message))
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
          messageBox = $('.message_box', topic)

      //NOTE: it's a prototype,
      //NOTE: at the moment message box can be openned (initialized) only once
      if (messageBox.is(":visible")) return

      //NOTE Temporary solution to have open only one chat
      // Close the other chats and clear
      $('.message_box').hide()
      $('.messages', messageBox).empty()

      // Fetch existing messages and run longpolling
      $.get(messageBox.data("index_url"))
       .success(function (data) {
        self.addMessages(messageBox, data.messages)
        self.poll(messageBox, data.timestamp)
      })

      messageBox.show()
    },

    init: function () {
      $('.topics').on("click", "form.new_message button", self.createMessage)
      $('.topics').on("click", "h4 a", self.initMessaging)
    }
  }

  self.init()
}
