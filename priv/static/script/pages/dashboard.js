requirejs.config(RequireConfig.getConfig());

requirejs([
    'kaedeApp',
    'bootstrap'
], function (KaedeApp) {
    KaedeApp.initialize();
});
