define(['Backbone'
], function (Backbone) {
  var Tag = Backbone.Model.extend({
    url: "/tag",
    parse: function (response) {
      this.id = response.tag.tag_id;
      return response.tag;
    }
  });
  return Tag;
});
