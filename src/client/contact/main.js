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
