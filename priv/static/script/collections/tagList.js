define([
	'Backbone',
	'models/tag'
], function (Backbone, TagModel) {
	var TagList = Backbone.Collection.extend({

		// Reference to this collection's model.
		model: TagModel,
		
		url: "/tag",
		
		parse: function (response) {
			return response.tags;
		}
	});
	return TagList;
});
