$ = require 'jquery'
module.exports = (settings, $ionicPopover) ->
  restrict: "E"
  controller: "AuthLangPickerController"
  templateUrl: "partials/auth-lang-picker.html"
  link: (scope, elem, attrs) ->
    if scope.langCode == 'en'
      scope.alpha2 = 'gb'
    else scope.alpha2 = scope.langCode
    
    scope.$watch "langCode", (newVal, oldVal) ->
      if newVal == 'en'
        scope.alpha2 = 'gb'
      else scope.alpha2 = newVal
      $(elem).find("i").removeAttr "class"
      $(elem).find("i").addClass "flag-icon"
      $(elem).find("i").addClass "flag-icon-#{scope.alpha2}"
    
    
    $ionicPopover.fromTemplateUrl "partials/auth-lang-picker-popover.html",
      scope: scope
    .then (popover) -> scope.popover = popover
       