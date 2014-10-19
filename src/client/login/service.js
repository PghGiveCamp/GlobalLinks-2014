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
