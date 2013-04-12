define(['Backbone'
       ], function (Backbone)
       {
	   var Topic = Backbone.Model.extend({
	       url: "/topic",
	       parse: function (response) {
                   this.id = response.topic.topic_id;
		   return response.topic;
	       }
	   });
	   return Topic;
       });
		
