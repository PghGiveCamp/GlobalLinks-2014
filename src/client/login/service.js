angular.module('globallinks.login.service', [
])
.factory('LoginSvc', function($http, $q, $window){
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
      $window.sessionStorage['username'] = JSON.stringify(user);
      deferred.resolve(user);
    }, function(error) {
      deferred.reject(error);
    });

    return deferred.promise;
  };

  return {
    login: login
  };
})
;
