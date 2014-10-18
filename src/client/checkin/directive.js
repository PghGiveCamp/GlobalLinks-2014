angular.module('globallinks.checkin.directive', [
	'ui.router',
	'checkin.template'
]).config(function($stateProvider) {
	var checkin = {
		name: 'checkin',
		url: '/checkin',
		views: {
 			'main': {
				templateUrl: 'checkin'
 			}
		}
	}

	$stateProvider.state(checkin);
});
