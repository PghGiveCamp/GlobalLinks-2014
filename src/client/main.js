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
