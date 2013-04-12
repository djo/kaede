define([
	'Backbone',
	'models/topic'
], function (Backbone, TopicModel) {
	var TopicList = Backbone.Collection.extend({

		// Reference to this collection's model.
		model: TopicModel,
		
		url: "/topic",
		
		parse: function (response) {
			return response.topics;
		}
	});
	return TopicList;
});