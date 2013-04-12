define([
    'collections/topicList',
    'views/topic/topicList',
    'collections/tagList',
    'views/tag/tagList'
], function (
    TopicListCollection, 
    TopicListView,
    TagListCollection, 
    TagListView) {
    var KaedeApp = {
	initialize: function () {
	    var self = this;
            self.init_collection(
                TopicListCollection, 
                TopicListView, 
                $('.topics'));

            self.init_collection(
                TagListCollection, 
                TagListView, 
                $('.tags'));
	    return self;
	},

        init_collection: function(Collection, View, target, opt){
            var collection = new Collection();
            var params = {
                el: target, 
		collection: collection };
            $.extend(params, opt);
            var view = new View(params);
            view.run();
        }
    };

    return KaedeApp;
});
