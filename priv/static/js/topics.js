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
