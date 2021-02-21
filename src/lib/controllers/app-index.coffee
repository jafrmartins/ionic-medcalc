class AppIndexController

  constructor: (
    $scope, 
    $filter,
    $rootScope, 
    ApiService,
    $translatePartialLoader
  ) ->
    
    _t = $filter 't'
    
    $translatePartialLoader.addPart 'app-index'
    
    $scope.$on '$stateChangeSuccess', ->
      if $rootScope.credentials then $scope.load()
    
    $rootScope.$on '$authCredentials', ->
      $scope.load(true)
    
    _map = ->
      _account = []
      $rootScope.credentials.scope.map (scope) ->
        [specialty, pack, calculator] = scope.split ":"
        if !specialty or !calculator then return
        $scope.calculators.map (calc) ->
          if calc.title is _t calculator
            calc.params =
              specialty: specialty 
              calculator: calculator
            _account.push calc
      _account = _account.sort (a, b) ->
        if a.title < b.title then return -1
        if a.title > b.title then return 1
        return 0
      _account
    
    $scope.load = (refreshCredentials) ->
      if refreshCredentials or !$scope.calculators
        Calculators = ApiService.resource 'calculators'
        Calculators.list (err, list) ->
          if err then throw new Error err
          $scope.calculators = list
          $scope.account = _map()
      else if !$scope.account
        $scope.account = _map()
  
module.exports = AppIndexController