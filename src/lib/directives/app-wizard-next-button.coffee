debounce = require 'lodash.debounce'

module.exports = ($rootScope) ->
  restrict: 'A'
  scope: 
    swiper: "="
    wizardNextButton: "&"
  link: (scope, elem, attrs) ->
    elem.bind 'click', -> scope.wizardNextButton()
    $rootScope.$on "$wizardIndexChange", debounce (event, index) ->
      if index is scope.swiper.slides.length-1
        elem.addClass "ng-hide"
      else
        elem.removeClass "ng-hide"
    , 250