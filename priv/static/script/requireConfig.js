var RequireConfig = {
	getConfig: function () {
		var config = {
			baseUrl: "/static/script/",
			paths: {
				'Underscore': 'lib/underscore-1.4.2',
				'Backbone': 'lib/backbone-0.9.2',
				'bootstrap': 'lib/bootstrap-2.0.4',
				'text': 'lib/require/plugins/text'
			},
			shim: {
				'Underscore': { exports: '_' },
				'Backbone': {
					deps: ['Underscore'],
					exports: 'Backbone'
				},
			}
		};

		return config;
	}
};
