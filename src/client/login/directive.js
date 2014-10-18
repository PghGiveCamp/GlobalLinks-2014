angular.module('globallinks.login.directive', [
	'ui.router',
	'login.template'
]).config(function($stateProvider) {
	$stateProvider.state({
		name: 'login',
		url: '/login',
		views: {
 			'main': {
				templateUrl: 'login'
 			}
		}
	});
});
