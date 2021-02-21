class AppRightSideMenuController
  
  constructor: (
    $scope,
    $rootScope,
    AuthService
  ) ->
    
    $scope.logout = ->
      AuthService.logout (err, res) ->
        if err then throw new Error "Logout: #{err.toString()}"
        if res.status is 200 then $rootScope.clearCredentials()
    
module.exports = AppRightSideMenuController