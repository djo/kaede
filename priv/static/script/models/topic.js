define(['Backbone'
	], function (Backbone)
	{
		var Topic = Backbone.Model.extend({
			url: "/topic",
			parse: function (response) {
				return response.topic;
			}
		});
		return Topic;
	});
		