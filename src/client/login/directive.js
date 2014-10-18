angular.module('globallinks.login.directive', [
	'ui.router',
	'login.template',
	'login.base.template',
	'login.resetpassword.template',
	'login.signup.template'
]).config(function($stateProvider) {
	var auth = {
		abstract: true,
		name: 'auth',
		url: '/auth',
		views: {
 			'main': {
				templateUrl: 'login'
 			}
		}
	},
	login = {
		name: 'auth.login',
		url: '/login',
		views: {
			'login': {
				templateUrl: 'login/base'
			}
		}
	},
	resetPassword = {
		name: 'auth.resetpassword',
		url: '/resetpassword',
		views: {
 			'login': {
				templateUrl: 'login/resetpassword'
 			}
		}
	},
	registerNewUser = {
		name: 'auth.signup',
		url: '/signup',
		views: {
 			'login': {
				templateUrl: 'login/signup'
 			}
		}
	}

	$stateProvider.state(auth);
	$stateProvider.state(login);
	$stateProvider.state(resetPassword);
	$stateProvider.state(registerNewUser);
});
