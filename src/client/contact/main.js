angular.module('globallinks.contact', [
  'ui.router',
  'contact.template',
  'globallinks.contact.service',
  'globallinks.login.service'
])
.config(function($stateProvider){
  $stateProvider.state({
    name: 'contact',
    url: '/contact',
    views: {
      'main': {
        templateUrl: 'contact',
        controller: 'ContactCtrl',
      }
    },
    resolve: {
      auth: function($q, LoginSvc){
        return LoginSvc.isLoggedInQ();
      }
    }
  });
})
.controller('ContactCtrl', function($scope, ContactSvc, StateAbbrvs){
  $scope.volunteer = ContactSvc.currentUser;
  $scope.stateAbbreviations = StateAbbrvs;
})
.value('StateAbbrvs', [
  "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID",
  "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS",
  "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK",
  "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV",
  "WI", "WY", "DC"
])
;
