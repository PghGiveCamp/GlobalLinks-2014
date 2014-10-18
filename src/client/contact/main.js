angular.module('globallinks.contact', [
  'ui.router',
  'contact.template'
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
    }
  });
})
.controller('ContactCtrl', function($scope, StateAbbrvs){
  $scope.volunteer = {
    name: "David Souther",
    address: {
      street: "401 Taylor St",
      city: "Pittsburgh",
      state: "PA",
      zip: "15224"
    },
    home: {
      email: 'davidsouther@gmail.com'
    },
    work: {},
    cell: {
      phone: "406 545 9223"
    },
    emergency: {
      name: "Annie Levine",
      relationship: "Fiancee"
    },
    waiver: {
      clause1: false,
      clause2: false,
      photo: false,
      all: false
    }
  };
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
