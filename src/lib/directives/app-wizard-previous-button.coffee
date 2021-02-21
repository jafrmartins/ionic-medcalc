debounce = require 'lodash.debounce'

module.exports = ($rootScope) ->
  restrict: 'A'
  scope: 
    swiper: "="
    wizardPreviousButton: "&"
  link: (scope, elem, attrs) ->
    elem.addClass "ng-hide"
    elem.bind 'click', -> scope.wizardPreviousButton()
    $rootScope.$on "$wizardIndexChange", debounce (event, index) ->
      if index is 0 then elem.addClass "ng-hide" else elem.removeClass "ng-hide"
    , 250