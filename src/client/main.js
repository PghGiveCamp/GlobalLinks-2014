angular.module('globallinks', [
	'globallinks.login',
	'globallinks.contact',
	'globallinks.checkin'
])
.controller('mainCtrl', function($scope, LoginSvc){
	$scope.auth = LoginSvc;
});
