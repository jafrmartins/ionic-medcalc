debounce = require 'lodash.debounce'

module.exports = ($rootScope) ->
  restrict: 'A'
  scope: 
    swiper: "="
    wizardExitButton: "&"
  link: (scope, elem, attrs) ->
    elem.bind 'click', -> scope.wizardExitButton()
    $rootScope.$on "$wizardIndexChange", debounce (event, index) ->
      if index > 0 then elem.addClass "ng-hide" else elem.removeClass "ng-hide"
    , 250