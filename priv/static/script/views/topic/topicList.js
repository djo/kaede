define([
    'Backbone',
    'models/topic',
    'views/topic/topicListItem',
    'text!templates/topic/topicList.html'
], function (Backbone, Topic, TopicListItemView, TopicListTemplate) {
    var TopicListView = Backbone.View.extend({
	tagName: 'div',
        
	events: {
	    'click .add-topic': 'createTopic'
	},
        pollingInterval: 5,
	
	initialize: function (args) {
	    this.collection.on('add remove reset change', this.render, this);
            
	    },
        
        run: function(){
            var self = this;
            self.collection.fetch();
            setInterval(
                function(){
                    self.collection.fetch();}, 
                1000 * self.pollingInterval);
        },
        
	render: function () {
	    var self = this;
	    self.$el.empty();
	    
	    var compiledTemplate = _.template(TopicListTemplate, {});
	    self.$el.html(compiledTemplate);
	    self.topicTextInput = self.$('.topic-text');
            
	    var container = self.$('.topic-list');
            
	    self.collection.each(function (topic, index) {
		var topicListItemView = new TopicListItemView({ model: topic });
		var row = topicListItemView.render().$el;
		container.prepend(row);
	    }, self);
	    
	    self.$('.no-topics').toggle(self.collection.length == 0);
            
	    return self;
	},
	
	createTopic: function(){
	    var self = this;
	    var topic = new Topic();
	    topic.save(
		{topic_text: self.topicTextInput.val()},
		{success: function(saved){ 
		    self.collection.add(saved); },
		 wait: true});
	},
        comparator: function(topic){
            return comment.get("topic_id");
        },
        
    });
    return TopicListView;
}); 
