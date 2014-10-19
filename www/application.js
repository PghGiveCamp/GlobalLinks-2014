(function(){
angular.module('globallinks.checkin', [
	'globallinks.checkin.directive'
]);

}).call(this);

(function(){
angular.module('globallinks.contact', [
  'ui.router',
  'contact.template',
  'globallinks.contact.service',
  'globallinks.login.service'
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
    },
    resolve: {
      auth: function($q, LoginSvc){
        return LoginSvc.isLoggedInQ();
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
angular.module('globallinks.login.resetpasswordToken', [
  'login.resetpasswordToken.template'
]).config(function($stateProvider){
  $stateProvider.state({
    name: 'auth.resetpasswordToken',
    url: '/resetpassword/:token',
    views: {
      'login': {
        templateUrl: 'login/resetpasswordToken',
        controller: function resetpasswordTokenCtrl(
          $http, $scope, $stateParams, $state
        ){
          $scope.reset = function resetpasswordToken(){
            $http.post('/reset_password', {
              reset_token: $stateParams.token,
              password: $scope.password
            }).then(
              function (success) {
                $state.go('checkin');
              },
              function (error) {
                $scope.error = error;
              }
            );
          }
        }
      }
    }
  });
});

}).call(this);

(function(){
angular.module('globallinks', [
	'globallinks.login',
	'globallinks.contact',
	'globallinks.checkin',
	'globallinks.quotes'
])
.config(function($urlRouterProvider){
	$urlRouterProvider.otherwise('/auth/login');
})
.controller('mainCtrl', function($scope, LoginSvc, $location, $timeout){
	$scope.auth = LoginSvc;

  $scope.isActive = function (viewLocation) {
    return viewLocation === $location.path();
  };
})
;

}).call(this);

(function(){
angular.module('globallinks.quotes', [
  'globallinks.quotes.directive'
])
.value('VolunteerQuotes', [
  {
    quote: "O​n behalf of GSK, we wish you great success. Know that we will continue our efforts to help support your wonderful organization.  Thanks to all of you for making us feel so welcome and sharing your mission.​",
    name: "​Barb D."
  },
  {
    quote: "It was truly a rewarding day for all of us.​",
    name: "​Barb D."
  },
  {
    quote: "O​n behalf of GSK, we wish you great success. Know that we will continue our efforts to help support your wonderful organization.  Thanks to all of you for making us feel so welcome and sharing your mission.​",
    name: "​Barb D."
  },
  {
    quote: "It was personally fulfilling to volunteer at Global Links seeing their work to help others do more, feel better, live longer.​",
    name: "​Patti"
  },
  {
    quote: "The experience was truly eye opening for all of us and we will definitely be looking to partner with you more in the future.  Your staff was friendly and very efficient at keeping us busy and leading our group.  We felt great on our way out the door, knowing that we had made a difference.​",
    name: "Dara K."
  },
  {
    quote: "I really enjoyed the time I spent there. I think what you do at Global Links is great and I really felt as though I made a difference when I volunteered there.​",
    name: "​Jess B."
  },
  {
    quote: "I really enjoy coming to Global Links. Such a wonderful and worthy cause.​",
    name: "​Tammi V."
  },
  {
    quote: "And thank YOU for always being so helpful and so much fun also! It really makes a difference for us volunteers and helps us to enjoy our time there.​",
    name: "​Tammi V."
  },
  {
    quote: "Global Links is so well organized that it makes the greatest possible use of volunteer time",
    name: "Anon."
  },
  {
    quote: "The best. I rarely do the others anymore because organization at the other place is not as nice as Global Links.  Everything is orderly and and straightforward so you feel like you have accomplished goals by the end of the volunteering...​",
    name: "Anon."
  },
  {
    quote: "Thanks for all you do to simultaneously reduce waste and save lives.  It's a beautiful thing.​",
    name: "Anon."
  },
  {
    quote: "I think you do an excellent job with organizing and keeping the volunteers buys and feeling useful.",
    name: "Anon."
  },
  {
    quote: "My volunteer experience has been exceptional.  Everything from the projects to the people has been great.",
    name: "Anon."
  }
])
;

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
  });

  Object.defineProperty(Contact.currentUser, 'status', (function(){
    var _status = '';
    return {
      set: function(_){ _status = _; },
      get: function(){
        if(_status.length > 0){
          return _status;
        }
        if(Contact.currentUser.checked_in){
          return 'started';
        }
        return '';
      }
    }
  }()));

  return Contact;
})
;

}).call(this);

(function(){
angular.module('globallinks.login.service', [
])
.factory('LoginSvc', function($q, $http, $window, UserKey){

  var user, storage = $window.localStorage;

  var finishLogin = function finishLogin(data){
    user = {
      name: data.username
    };
    storage[UserKey] = JSON.stringify(user);
    return user;
  };

  var login = function login(user, pass){
    return $http.post('/login', {
      username: user,
      password: pass
    }).success(finishLogin);
  };

  var logout = function logout(){
    delete storage[UserKey];
    return $http.post('/logout');
  };

  var isLoggedIn = function isLoggedIn(){
    return !angular.isUndefined(storage[UserKey]);
  };

  var isLoggedInQ = function isLoggedInQ(){
    var d = $q.defer();
    if(isLoggedIn()){
      d.resolve(true);
    } else {
      d.reject();
    }
    return d.promise;
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
    isLoggedInQ: isLoggedInQ,
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
		},
		resolve: {
			auth: function($q, LoginSvc){
				return LoginSvc.isLoggedInQ();
			}
		}
	};
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
						if ($scope.username) {
							ident = $scope.username;
						}
						else if ($scope.email) {
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

}).call(this);

(function(){
angular.module('globallinks.quotes.directive', [
  'ngAnimate',
  'quotes.template'
]).directive('quotes', function(){
  return {
    restrict: 'E',
    replace: true,
    templateUrl: 'quotes',
    controller: function($scope, VolunteerQuotes, $timeout){
      $scope.quotes = VolunteerQuotes;

      $scope.currentQuote = 0;
      (function advanceQuote() {
          $scope.currentQuote = Math.floor(Math.random() * VolunteerQuotes.length);
          $timeout(advanceQuote, 10000);
      }());
    }
  }
})
;

}).call(this);
