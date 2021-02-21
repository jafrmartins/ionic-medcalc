class AppLeftSideMenuController
  
  constructor: (
    $scope,
    $rootScope,
    AuthService
  ) ->
    
    $scope.sidemenu = [
      { icon: "fa fa-user-md", label: "SEARCH", sref: "app.index" },
      { icon: "fa fa-list", label: "BIBLIOGRAPHY", sref: "app.bibliography" }
    ]
    
module.exports = AppLeftSideMenuController