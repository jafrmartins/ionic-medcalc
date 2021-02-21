class AuthCredentialsController
  
  constructor: (
    $scope,
    AuthService,
    $localStorage,
    $state,
    $stateParams,
    $rootScope,
    CryptoService,
    NetMedicisService
  ) ->
    
    $scope.go = $rootScope.go
    $scope.clearCredentials = $rootScope.clearCredentials
    AuthService.setCredentials(
      username: $localStorage.username,
      token: $localStorage.token
    )

    { username, password } = AuthService.getCredentials()
    $rootScope.hasCredentials = username isnt undefined and password isnt undefined
    
    $rootScope.$on "$authCredentials", (e, credentials) ->
      $scope.route();
      
    $scope.route = ->
      if $state.current.name isnt "auth" && AuthService.isAnonymous()
        $scope.go "auth"
      else if $state.current.name is "auth" && !AuthService.isAnonymous()
        $scope.go "app.index"
      else if $state.current.name is "app.calculator.output"
        if !$rootScope.wizardOutput
          $scope.go "app.index", $stateParams

    AuthService.credentials $localStorage, (err, data) ->
      if err
        $scope.clearCredentials();
      else
        try
          $rootScope.$broadcast "$authCredentials", data
        catch err
          console.log err.message, err.stack

module.exports = AuthCredentialsController