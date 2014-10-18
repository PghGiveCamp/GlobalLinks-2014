(function(){
angular.module('globallinks.checkin', [
	'globallinks.checkin.directive'
]);

}).call(this);

(function(){
angular.module('globallinks.contact', [
  'ui.router',
  'contact.template',
  'globallinks.contact.service'
])
.config(function($stateProvider){
  $stateProvider.state({
    name: 'contact',
    url: '/contact',
    views: {
      'main': {
        templateUrl: 'contact',
        controller: 'ContactCtrl',
      }
    }
  });
})
.controller('ContactCtrl', function($scope, ContactSvc, StateAbbrvs){
  $scope.volunteer = ContactSvc.currentUser;
  $scope.stateAbbreviations = StateAbbrvs;
})
.value('StateAbbrvs', [
  "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID",
  "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS",
  "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK",
  "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV",
  "WI", "WY", "DC"
])
;

}).call(this);

(function(){
angular.module('globallinks.login', [
	'globallinks.login.directive'
]);

}).call(this);

(function(){
angular.module('globallinks', [
	'globallinks.login',
	'globallinks.contact',
	'globallinks.checkin'
])
.controller('mainCtrl', function($scope, LoginSvc){
	$scope.auth = LoginSvc;
});

}).call(this);

(function(){
angular.module('globallinks.contact.service', [
  'ngResource'
]).service('ContactSvc', function($resource){
  Contact = $resource('/contact', null, {
    checkin: { method: 'POST', url: '/contact/checkin' },
    checkout: { method: 'POST', url: '/contact/checkout' }
  });

  var u = Contact.currentUser = Contact.get();

  Object.defineProperty(Contact.currentUser, 'name', {
    get: function(){
      return (u.first_name || '') + ' ' + (u.last_name || '');
    }
  })

  return Contact;
});

}).call(this);

(function(){
angular.module('globallinks.login.service', [
])
.factory('LoginSvc', function($http, $window, UserKey){
  var user;

  var finishLogin = function finishLogin(data){
    user = {
      name: data.username
    };
    $window.sessionStorage[UserKey] = JSON.stringify(user);
    return user;
  };

  var login = function login(user, pass){
    return $http.post('/login', {
      username: user,
      password: pass
    }).success(finishLogin);
  };

  var logout = function logout(){
    delete $window.sessionStorage[UserKey];
    return $http.post('/logout');
  };

  var isLoggedIn = function isLoggedIn(){
    return !angular.isUndefined($window.sessionStorage[UserKey]);
  };

  var register = function register(username, password, email){
    return $http.post('/user', {
      username: username,
      password: password,
      email: email
    }).success(finishLogin);
  };

  return {
    login: login,
    logout: logout,
    isLoggedIn: isLoggedIn,
    register: register
  };
}).value('UserKey', 'user')
;

}).call(this);

(function(){
angular.module('globallinks.checkin.directive', [
	'ui.router',
	'checkin.template'
]).config(function($stateProvider) {
	var checkin = {
		name: 'checkin',
		url: '/checkin',
		views: {
 			'main': {
				templateUrl: 'checkin',
				controller: 'CheckinCtrl'
 			}
		}
	}

	$stateProvider.state(checkin);
})
.controller('CheckinCtrl', function($scope, ContactSvc){
  $scope.volunteer = ContactSvc.currentUser;
  $scope.checkin = function() {
  	ContactSvc.currentUser.$checkin().then(function(){
  		$scope.volunteer.status = 'started';
  	});
  }
  $scope.checkout = function() {
  	ContactSvc.currentUser.$checkout().then(function(){
  		$scope.volunteer.status = 'done';
  	});
  }
});

}).call(this);

(function(){
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

}).call(this);
