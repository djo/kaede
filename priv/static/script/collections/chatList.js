define([
  'Backbone',
  'models/topic'
], function (Backbone, Topic) {
  var ChatList = Backbone.Collection.extend({
    model: Topic,
  });
  return ChatList;
});
