debounce = require 'lodash.debounce'

class AppTabAboutController
  constructor: (
    $scope,
    $rootScope,
    $translatePartialLoader,
    ApiService,
    $filter,
    $stateParams,
    NetMedicisService
  ) ->
  
    $translatePartialLoader.addPart 'app-tab'
    $scope.calculator = false
    _t = $filter 't'
    Calculators = ApiService.resource 'calculators'
    Calculators.list (err, list) ->
      list.map (calculator) ->
        if calculator.title is _t $stateParams.calculator
          $scope.calculator = calculator
    
module.exports = AppTabAboutController