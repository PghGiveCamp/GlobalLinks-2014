angular.module('globallinks.quotes.directive', [
  'ngAnimate',
  'quotes.template'
]).directive('quotes', function(){
  return {
    restrict: 'E',
    replace: true,
    templateUrl: 'quotes',
    controller: function($scope, VolunteerQuotes, $timeout){
      $scope.quotes = VolunteerQuotes;

      $scope.currentQuote = 0;
      (function advanceQuote() {
          $scope.currentQuote = Math.floor(Math.random() * VolunteerQuotes.length);
          $timeout(advanceQuote, 10000);
      }());
    }
  }
})
;
