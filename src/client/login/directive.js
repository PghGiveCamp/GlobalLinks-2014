angular.module('globallinks.login.directive', [
	'ui.router',
	'globallinks.login.service',
	'globallinks.login.resetpasswordToken',
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
				templateUrl: 'login/resetpassword',
				controller: function($http, $scope) {
					$scope.request_reset_password = function() {
						var ident = '';
						$scope.sent_request = false;
						if ($scope.username.length > 0) {
							ident = $scope.username;
						}
						else if ($scope.email.length > 0) {
							ident = $scope.email;
						}
						return $http.post('/request_reset_password', {
							user_identifier: ident
						}).then(
							function(response){
								$scope.sent_request = true;
							},
							function(error){
							}
						);
					}
				}
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
	}

	$stateProvider.state(auth);
	$stateProvider.state(login);
	$stateProvider.state(resetPassword);
	$stateProvider.state(registerNewUser);
});
