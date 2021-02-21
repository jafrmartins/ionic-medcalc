class AuthLangPickerController

  constructor: (
    $scope,
    $translate,
    $localStorage
  ) ->
    
    $scope.langCode = $translate.use()
    $scope.changeLang = (code) ->
      $scope.langCode = code
      $localStorage.lang = code
      $translate.use(code)

module.exports = AuthLangPickerController