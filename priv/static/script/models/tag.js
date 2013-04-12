define(['Backbone'
       ], function (Backbone)
       {
	   var Tag = Backbone.Model.extend({
	       url: "/tag",
	       parse: function (response) {
		   return response.tag;
	       }
	   });
	   return Tag;
       });
		
