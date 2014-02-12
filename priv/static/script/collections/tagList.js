define([
  'Backbone',
  'models/tag'
], function (Backbone, TagModel) {
  var TagList = Backbone.Collection.extend({
    model: TagModel,
    url: "/tag",
    parse: function (response) { return response.tags; }
  });
  return TagList;
});
