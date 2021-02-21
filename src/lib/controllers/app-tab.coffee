class AppTabController
  
  constructor: (
    $scope,
    $rootScope
  ) ->
    
    $scope.tabs =[
      {
        name: "output",
        iconOn: "ion-ios-pie-outline",
        iconOff: "ion-ios-pie",
        state: "app.tab.output"
      },
      {
        name: "about",
        iconOn: "ion-ios-book-outline",
        iconOff: "ion-ios-book",
        state: "app.tab.about"
      }
    ]
      
    
module.exports = AppTabController