debounce = require 'lodash.debounce'

class AppTabOutputController
  constructor: (
    $scope,
    $rootScope,
    $translatePartialLoader,
    ApiService,
    $filter,
    $stateParams,
    NetMedicisService,
    $timeout
  ) ->

    { specialty: $scope.s, pack: $scope.p, calculator: $scope.c } = $stateParams
    
    $translatePartialLoader.addPart "app-tab"
    $translatePartialLoader.addPart "wizard-#{$scope.s}-#{$scope.p}-#{$scope.c}"
    $scope.selectedItem = 0
    $scope.selectedValue = 0
    $scope.output = $rootScope.wizardOutput
    $scope.input = $rootScope.wizardInput
    $scope.display = $rootScope.wizardDisplay
    
module.exports = AppTabOutputController