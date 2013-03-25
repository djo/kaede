function Topics (startTimestamp) {
  var topicTemplate = _.template($("#topic").html()),
      topicList = $(".topics"),
      topicForm = $("form.new_topic"),
      topicText = $('.topic_text', topicForm),

  self = {
    addTopics: function (topics) {
      _.each(topics, function (topic) {
        topicList.append(topicTemplate(topic))
      })
    },

    createTopic: function (e) {
      e.preventDefault()

      $.ajax({
        url: "/topic/create",
        type: 'POST',
        data: { topic_text: topicText.val() }
      }).success(function (data) {
        console.log(data)
        topicText.val("")
      }).error(function (jqXHR) {
        alert("Errors: " + jqXHR.responseText)
      })
    },

    poll: function (timestamp) {
      setTimeout(function () {
        $.get("/topic/pull/" + timestamp, function (data) {
          console.log(data)
          self.addTopics(data.topics)
          self.poll(data.timestamp)
        })
      }, 1000)
    },

    init: function () {
      topicForm.submit(self.createTopic)
      self.poll(startTimestamp)
    }
  }

  self.init()
}
