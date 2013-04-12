define([
    'Backbone',
    'text!templates/tag/tagListItem.html'
], function (Backbone, TagListItemTemplate) {
    var TagListItemView = Backbone.View.extend({
	tagName: 'a',
	className: 'tag-item',
        
	render: function () {
	    var self = this;
	    var compiledTemplate = _.template(TagListItemTemplate, self.model.toJSON());
	    self.$el.html(compiledTemplate);
	    return self;
	}
    });
    return TagListItemView;
}); 
