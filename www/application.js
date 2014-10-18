(function(){
angular.module('globallinks.contact', [
  'ui.router',
  'contact.template'
]).config(function($stateProvider){
  $stateProvider.state({
    name: 'contact',
    url: '/contact',
    views: {
      'main': {
        templateUrl: 'contact'
      }
    }
  });
});

}).call(this);

(function(){
angular.module('globallinks.login', [
	'globallinks.login.directive'
]);

}).call(this);

(function(){
angular.module('globallinks', [
	'globallinks.login',
	'globallinks.contact'
]);

}).call(this);

(function(){
angular.module('globallinks.login.directive', [
	'ui.router',
	'login.template'
]).config(function($stateProvider) {
	$stateProvider.state({
		name: 'login',
		url: '/login',
		views: {
 			'main': {
				templateUrl: 'login'
 			}
		}
	});
});

}).call(this);
