define([
    'Backbone',
    'text!templates/topic/topicListItem.html'
], function (Backbone, TopicListItemTemplate) {
    var TopicListItemView = Backbone.View.extend({
	tagName: 'div',
	className: 'topic-item',
        
	render: function () {
	    var self = this;
	    var compiledTemplate = _.template(TopicListItemTemplate, self.model.toJSON());
	    self.$el.html(compiledTemplate);
	    return self;
	}
    });
    return TopicListItemView;
}); 
