module.exports = ($rootScope) ->
  restrict: 'A'
  require: 'ngModel',
  scope: '=',
  link: (scope, elem, attrs, ngModel) ->

    { wizardFormElement: slide, wizardForm: form } = scope.$parent.$parent

    if slide and form
      
      _skipWizard = (viewValue) ->
        if viewValue is slide.finish
          $rootScope.$broadcast "$wizardSkip", true
      
      _parseFloat = (viewValue) -> 
        parseFloat viewValue
      
      _validOption = (viewValue) ->
        ngModel.$setValidity 'validOption', false
        options = slide.options.reduce (opts, opt) ->
          opts.concat opt.value
        , []
        if viewValue and options.indexOf(viewValue) isnt -1
          ngModel.$setValidity 'validOption', true
          ngModel.$setViewValue(viewValue)
          ngModel.$setDirty()
          ngModel.$setTouched()
          ngModel.$validate()
          ngModel.$render()
        form[ngModel.$name] = ngModel
        return viewValue
      
      if slide.type is 'number'
        ngModel.$formatters.push _parseFloat
      
      if slide.type is 'radio'
        ngModel.$formatters.push _validOption
        ngModel.$parsers.push _validOption
      
      if slide.finish
        ngModel.$formatters.push _skipWizard
        ngModel.$parsers.push _skipWizard
      