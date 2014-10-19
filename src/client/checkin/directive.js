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
