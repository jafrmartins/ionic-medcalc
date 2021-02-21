debounce = require 'lodash.debounce'

class AppBibliographyController
  constructor: (
    $translatePartialLoader, 
    $scope, 
    $filter, 
    $ionicViewSwitcher,
    $state,
    $rootScope,
    ApiService
  ) ->
    
    $translatePartialLoader.addPart 'app-bibliography'
    
    $scope.offset = 0
    $scope.limit = 25
    Calculator = ApiService.resource 'calculators'
    
    $scope.$on '$stateChangeSuccess', ->
      $scope.load()
    
    $rootScope.$on '$authCredentials', ->
      $scope.load()
    
    _t = $filter('t')
    _translate = $filter('translate')

    $scope.transform = (data) ->
      _col = {}
      _current = undefined
      data.map (item, i) ->
        if _current is item.params.specialty
          _col[_current].push item
          return false
        _current = item.params.specialty
        _col[_current] = []
        _col[_current].push item
      _sort = (_data) -> _data.sort (a, b) ->
        if a.title < b.title then return -1
        if a.title > b.title then return 1
        return 0
      _data = []
      Object.keys(_col).map (key) -> 
        _data = _data.concat [ { "title": key, "isSpecialty": true } ].concat _sort _col[key]
      _data

    $scope.load = ->
      $scope.q = ""
      $scope.moreData = true
      $scope.loadMoreData()
      $scope.credentials = $rootScope.credentials
    
    $scope.loadMoreData = debounce ->
      query = limit: $scope.limit
      if $scope.offset
        if $scope.offset <= $scope.limit
          $scope.moreData = false
        else 
          query.offset = $scope.offset
      if $scope.moreData
        Calculator.list query, (err, data)->
          if data.length is 0
            $scope.moreData = false
          data = data.map (calc) ->
            [ specialty, pack, calculator ] = calc.scope.title.split(":")
            if !specialty or !calculator then return
            calc.params =
              specialty: specialty 
              calculator: calculator
            calc
          $scope.offset += data.length
          $scope.calculators ?= []
          $scope.calculators = $scope.transform $scope.calculators.concat data || [] 
          $scope.$broadcast 'scroll.infiniteScrollComplete'
      else
        $scope.$broadcast 'scroll.infiniteScrollComplete'
    , 500
        
module.exports = AppBibliographyController