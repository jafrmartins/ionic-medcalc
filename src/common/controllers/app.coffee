class AppController

  constructor: (
    $scope,
    $rootScope,
    $translatePartialLoader,
    $translate,
    $state,
    $localStorage,
    $ionicPopup,
    $filter,
    settings;
    CryptoService
  ) ->

    $translatePartialLoader.addPart 'app'
    $scope.logo = "#{settings.app.logo}"
    $scope.copyright = "#{settings.app.copyright}"

    { name } = $rootScope.$state.current

    _popup = ->
      if /^auth$|^app.wizard$|^app.tab/.test(name)
        return false
      if $scope.termsOfUsagePopup is undefined
        $translate('TERMS_OF_USAGE_POPUP_TEXT').then (termsOfUsage) ->
          $translate('TERMS_OF_USAGE_POPUP_TITLE').then (title) ->
            $translate('TERMS_OF_USAGE_POPUP_SUBTITLE').then (subtitle) ->
              $translate('TERMS_OF_USAGE_POPUP_DISMISS_BUTTON').then (button) ->
                $scope.welcomePopupMessage = termsOfUsage 
                _termsOfUsagePopup = 
                  cssClass: 'tos-popup',
                  templateUrl: 'partials/app-welcome-popup.html',
                  title: title
                  subTitle: subTitle,
                  buttons: [{ text: button }],
                  scope: $scope
                $scope.termsOfUsagePopup = $ionicPopup.show _termsOfUsagePopup
    _popup()

    $rootScope.$on '$authCredentials', (e, credentials) ->
      $rootScope.credentials = credentials
      $localStorage.credentials = CryptoService.cipher JSON.stringify(credentials), credentials.token

module.exports = AppController