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
