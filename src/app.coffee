require 'ngstorage'
require 'angular-translate'
require 'angular-translate-loader-partial'
require 'ionic-wizard/dist/ion-wizard'

app = angular.module "app", [ 
  "ionic",
  "pascalprecht.translate", 
  "base64",
  "ngStorage",
  "ionic.wizard" 
]

### ./common ###

app.constant "states", require './common/constants/states'
app.constant "settings", require './common/constants/settings'

app.controller "RootController", require './common/controllers/root'
app.controller "AuthController", require './common/controllers/auth'
app.controller "AuthCredentialsController", require './common/controllers/auth-credentials'
app.controller "AuthLangPickerController", require './common/controllers/auth-lang-picker'
app.controller "AppController", require './common/controllers/app'
app.controller "AppLeftSideMenuController", require './common/controllers/app-left-side-menu'
app.controller "AppRightSideMenuController", require './common/controllers/app-right-side-menu'

app.directive "app-include", require './common/directives/app-include'
app.directive "app-left-side-menu", require './common/directives/app-left-side-menu'
app.directive "app-right-side-menu", require './common/directives/app-right-side-menu'
app.directive "auth-credentials", require './common/directives/auth-credentials'
app.directive "auth-lang-picker", require './common/directives/auth-lang-picker'

app.filter "capitalize", require './common/filters/capitalize'

app.service "ApiService", require './common/services/api'
app.service "CryptoService", require './common/services/crypto'
app.service "AuthService", require './common/services/auth'

### ./lib ###

app.controller "AppIndexController", require './lib/controllers/app-index'
app.controller "AppBibliographyController", require './lib/controllers/app-bibliography'
app.controller "AppWizardController", require './lib/controllers/app-wizard'
app.controller "AppTabController", require './lib/controllers/app-tab'
app.controller "AppTabAboutController", require './lib/controllers/app-tab-about'
app.controller "AppTabOutputController", require './lib/controllers/app-tab-output'

app.directive "appWizardFormElement", require './lib/directives/app-wizard-form-element'
app.directive "appWizardExitButton", require './lib/directives/app-wizard-exit-button'
app.directive "appWizardPreviousButton", require './lib/directives/app-wizard-previous-button'
app.directive "appWizardNextButton", require './lib/directives/app-wizard-next-button'
app.directive "appWizardContinueButton", require './lib/directives/app-wizard-continue-button'
app.directive "appWizardInput", require './lib/directives/app-wizard-input'

app.service "NetMedicisService", require './lib/services/netmedicis'

app.filter "t", require './lib/filters/t'
app.filter "calculator", require './lib/filters/calculator'

app.config ($stateProvider, $urlRouterProvider, states) ->
  if states?.otherwise?.url then $urlRouterProvider.otherwise states.otherwise.url
  Object.keys(states).map (state) ->
    unless state is 'otherwise' then $stateProvider.state(
      state, states[state]
    )

app.config ($translateProvider, $ionicConfigProvider, settings) ->
  
  $ionicConfigProvider.tabs.position 'bottom'
  
  $translateProvider.useLoader '$translatePartialLoader',
    urlTemplate: 'i18n/{lang}-{part}.json'

  $translateProvider.registerAvailableLanguageKeys(
    settings.i18n.langs, settings.i18n.locales
  )

  $translateProvider.useLoaderCache(true)
  $translateProvider.determinePreferredLanguage()
  $translateProvider.useSanitizeValueStrategy null
    
app.run (
  $ionicPlatform, 
  $state, 
  $rootScope, 
  $stateParams, 
  settings,
  $translate, 
  $localStorage, 
  $ionicViewSwitcher,
  AuthService
) ->

  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams
  
  $rootScope.$once = (e, func) ->
    unhook = @$on e, ->
      unhook()
      func.apply(this, arguments)

  $rootScope.go = (state, params={}, direction='forward') ->
    $ionicViewSwitcher.nextDirection direction
    $state.go state, params

  $rootScope.clearCredentials = ->
    AuthService.clearCredentials()
    $localStorage.username = undefined
    $localStorage.token = undefined
    $localStorage.credentials = undefined
    $rootScope.hasCredentials = false
    if $state.current.name isnt "auth"
      $rootScope.go "auth"
  
  $rootScope.$on "$translatePartialLoaderStructureChanged", ->
    $translate.refresh()
    
  if $localStorage.lang then $translate.use $localStorage.lang
    
  $ionicPlatform.ready ->
    if window.cordova && window.cordova.plugins.Keyboard
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true)
      cordova.plugins.Keyboard.disableScroll(true)
    if window.StatusBar
      StatusBar.styleDefault()