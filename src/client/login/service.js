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
