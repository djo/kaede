define([
    'collections/topicList',
    'views/topic/topicList'
], function (TopicListCollection, TopicListView) {
    var KaedeApp = {
	initialize: function () {
	    var self = this;
	    var topicListCollection = new TopicListCollection();
	    var topicListView = new TopicListView({ 
		el: $('.topics'), 
		collection: topicListCollection });
	    topicListView.runPolling();

	    return self;
	},
    };

    return KaedeApp;
});
