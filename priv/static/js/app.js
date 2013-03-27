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
