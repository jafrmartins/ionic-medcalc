class AuthController

  constructor: (
    $scope,
    $rootScope,
    $translate,
    $state,
    $timeout,
    settings,
    $ionicPopup,
    $translatePartialLoader,
    AuthService,
    $localStorage,
    CryptoService
  ) ->
    
    $scope.settings = settings.auth
    $scope.go = $rootScope.go
    $scope.form = {
      controller: {},
      data: {}
    }

    $translatePartialLoader.addPart 'auth'

    $scope.isFormError = (form, field) ->
      ctrl = $scope.form.controller[form]["#{form}.#{field}"]
      ctrl.$dirty and ctrl.$invalid
    
    $scope.showFormError = (form, field) ->
      ctrl = $scope.form.controller[form]["#{form}.#{field}"]
      if ctrl.$dirty and ctrl.$invalid
        $translate('FORM_INPUT_ERROR').then (title) ->
          $translate("FORM_AUTH_#{field.toUpperCase()}").then (subtitle) ->
            $scope.errorCtrl = ctrl
            $ionicPopup.alert
              okText: 'Ok',
              scope: $scope,
              cssClass: 'auth-popup',
              title: title,
              subTitle: subtitle,
              templateUrl: "partials/auth/input-popup.html"

    $scope.connectionError = ->
      $translate("FORM_AUTH_CONNECTION_ERROR").then (subtitle) ->
        $ionicPopup.alert
          okText: 'Ok',
          scope: $scope,
          cssClass: 'auth-popup',
          title: subtitle,
          subTitle: subtitle,
          templateUrl: "partials/auth/connection-error-popup.html"

    $scope.login = ->
      ctrl = $scope.form.controller.login
      if ctrl.$dirty and ctrl.$valid
        AuthService.login { 
          provider: "login",
          email: $scope.form.data.login.email, 
          password: $scope.form.data.login.password 
        }, (err, res) ->
          if err then $scope.connectionError()
          else if res.status is 200
            AuthService.setCredentials(res)
            $localStorage.username = res.username
            $localStorage.token = res.token
            $scope.go "app.profile"
        
    $scope.register = ->
      ctrl = $scope.form.controller.register
      if ctrl.$dirty and ctrl.$valid
        AuthService.register {
          name: $scope.form.data.register.name,
          email: $scope.form.data.register.email,
          password: $scope.form.data.register.password
        }, (err, res) ->
          if err then $scope.connectionError()
          else if res.status is 200
            AuthService.setCredentials(res)
            $localStorage.username = res.username
            $localStorage.token = res.token
            $scope.go "app.profile"

module.exports = AuthController