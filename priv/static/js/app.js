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
        self.addTopics([data.topic])
      }).error(function (jqXHR) {
        alert("Errors: " + jqXHR.responseText)
      })
    },

    init: function () {
      topicForm.submit(self.createTopic)
      $.get(topicList.data('list_url'))
       .success(function (data) {
         self.addTopics(data.topics)
      })
    }
  }

  self.init()
}

function Messages () {
  var messageTemplate = _.template($("#message").html()),
      topicContentTemplate = _.template($("#topic-content").html()),
      topicMessages = $('.topic-messages'),

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

    showMessages: function (e) {
      e.preventDefault()

      var topic = $(this).parents('.topic')
      var topicContent = topicContentTemplate(topic.data('topic'))
      topicMessages.html(topicContent)
      
      var messageBox = $('.message_box', topicMessages)
      var submitButton = $('.new_message button', messageBox)
      submitButton.click(self.createMessage)

      $.get(messageBox.data("list_url"))
       .success(function (data) {
         self.addMessages(messageBox, data.messages)
         self.poll(messageBox, data.timestamp)
      })
    },

    init: function () {
      $('.topics').on("click", "h4 a", self.showMessages)
    }
  }

  self.init()
}

function Tags () {
  var tagTemplate = _.template($("#tag").html()),
      tagList = $('.tag-list'),

  self = {
    addTags: function (tags) {
      _.each(tags, function (tag) {
        tagList.append(tagTemplate(tag))
      })
    },

    init: function () {
      $.get(tagList.data("list_url"))
       .success(function (data) {
         self.addTags(data.tags)
      })
    }
  }

  self.init()
}
