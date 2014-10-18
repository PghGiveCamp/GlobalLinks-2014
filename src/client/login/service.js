angular.module('globallinks.login.service', [
])
.factory('LoginSvc', function($http, $q, $window, UserKey){
  var user;

  var login = function login(user, pass){
    var deferred = $q.defer();

    $http.post('/login', {
      username: user,
      password: pass
    }).success(function(data){
      user = {
        name: data.username
      };
      $window.sessionStorage[UserKey] = JSON.stringify(user);
      deferred.resolve(user);
    }, function(error) {
      deferred.reject(error);
    });

    return deferred.promise;
  };

  var logout = function logout(){
    $http.post('/logout');
    delete $window.sessionStorage[UserKey];
  };

  var isLoggedIn = function(){
    return !angular.isUndefined($window.sessionStorage[UserKey]);
  };

  return {
    login: login,
    logout: logout,
    isLoggedIn: isLoggedIn
  };
}).value('UserKey', 'user')
;
