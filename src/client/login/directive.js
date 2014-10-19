angular.module('globallinks.login.directive', [
	'ui.router',
	'globallinks.login.service',
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
				templateUrl: 'login/base',
				controller: function($scope, $state, LoginSvc){
					$scope.username = '';
					$scope.password = '';
					$scope.error = null;
					$scope.login = function(){
						LoginSvc.login($scope.username, $scope.password).then(
							function(user){
								$state.go('checkin');
							},
							function(error){
								$scope.error = error;
							}
						)
					};
				}
			}
		},
		resolve: {
			auth: function($q, $state, LoginSvc){
				if(LoginSvc.isLoggedIn()){
					$state.go('checkin');
					return $q.reject('Redirecting...');
				} else {
					return true;
				}
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
				templateUrl: 'login/signup',
				controller: function($scope, $state, LoginSvc){
					$scope.email = '';
					$scope.username = '';
					$scope.password = '';
					$scope.error = null;
					$scope.register = function(){
						LoginSvc.register($scope.username, $scope.password, $scope.email)
						.then(
							function(user){
								$state.go('checkin');
							},
							function(error){
								$scope.error = error;
							}
						)
					};
				}
 			}
		}
	}

	$stateProvider.state(auth);
	$stateProvider.state(login);
	$stateProvider.state(resetPassword);
	$stateProvider.state(registerNewUser);
});
