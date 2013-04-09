var activeRequest = undefined

function Messages () {
  var messageTemplate = _.template($("#message").html()),
      topicContentTemplate = _.template($("#topic-content").html()),
      topicMessages = $('.topic-messages')

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
      if (activeRequest != undefined)
        activeRequest.abort()

      setTimeout(function () {
        var url = messageBox.data("poll_url") + "/" + timestamp

        activeRequest = $.ajax({
          type: "GET",
          url: url,
          cache: false,
          timeout: 20000,
          success: function (data) {
            self.addMessages(messageBox, data.messages)
            self.poll(messageBox, data.timestamp)
          },
          error: function (xhr) {
            if (xhr.statusText !== "abort") {
              activeRequest = undefined
              self.poll(messageBox, timestamp)
            }
          }
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

      $.ajax({
        type: "GET",
        url: messageBox.data("list_url"),
        success: function (data){
          self.addMessages(messageBox, data.messages)
          self.poll(messageBox, data.timestamp)
        }
      })
    },

    init: function () {
      $('.topics').on("click", "h4 a", self.showMessages)
    }
  }

  self.init()
}
