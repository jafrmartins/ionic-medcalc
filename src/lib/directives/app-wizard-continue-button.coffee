debounce = require 'lodash.debounce'

module.exports = ($rootScope) ->
  restrict: 'A'
  scope: 
    swiper: "="
    wizardContinueButton: "&"
  link: (scope, elem, attrs) ->
    elem.addClass "ng-hide"
    elem.bind 'click', -> scope.wizardContinueButton()
    $rootScope.$on "$wizardIndexChange", debounce (event, index) ->
      if index is scope.swiper.slides.length-1
        elem.removeClass "ng-hide" 
      else elem.addClass "ng-hide"
    , 250