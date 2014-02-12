define([
  'Backbone',
  'models/topic'
], function (Backbone, TopicModel) {
  var TopicList = Backbone.Collection.extend({
    model: TopicModel,
    url: "/topic",
    parse: function (response) { return response.topics; }
  });
  return TopicList;
});
