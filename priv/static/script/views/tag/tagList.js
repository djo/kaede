define([
    'Backbone',
    'models/tag',
    'views/tag/tagListItem',
    'text!templates/tag/tagList.html'
], function (Backbone, Tag, TagListItemView, TagListTemplate) {
  var TagListView = Backbone.View.extend({
    tagName: 'div',

    initialize: function (args) {
      this.collection.on('add remove reset change', this.render, this);
    },

    run: function(){
      var self = this;
      self.collection.fetch();
    },

    render: function () {
      var self = this;
      self.$el.empty();

      var compiledTemplate = _.template(TagListTemplate, {});
      self.$el.html(compiledTemplate);
      var container = self.$('.tag-list');

      self.collection.each(function (tag, index) {
        var tagListItemView = new TagListItemView({ model: tag });
        var row = tagListItemView.render().$el;
        container.append(row);
      }, self);

      return self;
    }
  });

  return TagListView;
}); 
