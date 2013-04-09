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
