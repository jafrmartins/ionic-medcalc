class RootController

  constructor: (
    $scope,
    $rootScope,
    $translatePartialLoader,
    $translate,
    $localStorage,
    settings,
    CryptoService
  ) ->

    $translatePartialLoader.addPart 'main'
    $scope.logo = "#{settings.app.logo}"
    $scope.copyright = "#{settings.app.copyright}"

    $rootScope.$on '$authCredentials', (e, credentials) ->
      $rootScope.credentials = credentials
      $localStorage.credentials = CryptoService.cipher JSON.stringify(credentials), credentials.token

module.exports = RootController