$ = require 'jquery'
debounce = require 'lodash.debounce'

class AppWizardController
  constructor: (
    $scope,
    $rootScope,
    $translatePartialLoader,
    NetMedicisService,
    $filter,
    $injector,
    $state,
    $stateParams,
    $ionicScrollDelegate,
    $timeout,
    $ionicHistory
  ) ->
    
    $scope.wizard = loaded: false, data: {}, response: null
    $scope.Keyboard = cordova?.plugins?.Keyboard
    
    _slideEvents = []
    _eventListeners = []
    $scope.$on "$destroy", ->
      $scope?.Keyboard?.close()
      _eventListeners.map (e) -> e()
      _slideEvents.map (e) -> e.target.unbind "#{e.type}"
    
    _eventListeners.push $scope.$on "$wizardSkip", (event, data) ->
      $scope.finished = true
      $scope.continue()

    _eventListeners.push $scope.$on "$wizardKeyboardData", (event, data) ->
      { index, slide } = data
      if index is 0 then _slideEvents.map (e) -> e.target.unbind "#{e.type}"
      _attach = ->
        sel = "[name='#{@slide.name}']"
        if @slide.type is "radio"
          sel = "#{sel} input[type='radio']"
        $(sel).unbind 'focusin'
        $(sel).unbind 'click'
        $(sel).unbind 'keydown'
        $(sel).unbind 'blur'
        _slideEvents.push
          type: 'blur'
          target: $(sel).one 'blur', _blurHandler
        if @slide.type is "radio"
          _slideEvents.push
            type: 'focusin'
            target: $("#{sel} input[type='radio']").first().one 'focusin', _focusInHandler
          _slideEvents.push
            type: 'click'
            target: $(sel).on 'click', debounce _clickHandler, 250
          _slideEvents.push
            type: 'keydown'
            target: $(sel).on 'keydown', _keydownHandler
        else if @slide.type is "number"
          _slideEvents.push
            type: 'focusin'
            target: $(sel).one 'focusin', _focusInHandler
          _slideEvents.push
            type: 'keydown'
            target: $(sel).on 'keydown', _keydownHandler
      if not $scope.wizard.loaded
        $scope.wizard.loaded = true
        $timeout _attach.bind({ index: index, slide: slide })(), 250
      else _attach.bind({ index: index, slide: slide })()

    _eventListeners.push $scope.$on "$wizardSlideTo", (event, data) ->
      $scope.swiper.slideTo data.index
      _focusInput data.target
    
    _eventListeners.push $scope.$on '$stateChangeSuccess', (ev, to, toParams, from, fromParams) ->
      $scope.wizard.data = {}
      $scope.wizard.loaded = false
      if $scope?.swiper and to.name isnt "app.calculator.output"
        _slideTo()
      else if $rootScope.credentials then $scope.load()
    
    _eventListeners.push $scope.$on "$authCredentials", -> $scope.load()
    
    _eventListeners.push $scope.$on "$ionicSlides.sliderInitialized", (event, data) ->
      $scope.swiper = data.slider
      _swipeLock(data.slider)
      if $rootScope.credentials
        if not $scope.wizard.loaded
          $scope.load() 
        else _slideTo()
    
    _eventListeners.push $scope.$on "$ionicSlides.slideChangeStart", (event, data) ->
      _wizardKeyboardData data.slider.activeIndex
      $rootScope.$broadcast "$wizardIndexChange", data.slider.activeIndex

    _target = (i) ->
      slide = $scope.wizard.response.schema.slides[i]
      $ "[name='#{slide.name}']"

    _updateKeyboard = (target) ->
      if $scope.Keyboard and not $scope.Keyboard.isVisible and target.attr('type') is 'number'
        $scope.Keyboard.show()

    _updatePagination = (i) ->
      $(".swiper-pagination-bullet").removeClass "swiper-pagination-bullet-active"
      $(".swiper-pagination-bullet[index='#{i}']").addClass "swiper-pagination-bullet-active"
    
    _updateNavigation = (i) ->
      if $scope.Keyboard and not $scope.isNextAvailable(i)
        $(".footer > .button.next").addClass 'disabled'
    
    _currentIndex = 0
    _swipeLock = (slider) ->
      $scope.$watch 'swiper', (swiper) ->
        if not swiper then return false
        swiper.on 'onTransitionStart', (e) ->
          $timeout -> _currentIndex = e.activeIndex
        $scope.$watch ->
          if $scope.wizard.form
            return $scope.isNextAvailable(_currentIndex)
          else return false
        , ->
          if not $scope.swiper and not $scope.wizard.form then return false
          $scope.swiper.lockSwipeToNext()
          allowNext = $scope.isNextAvailable(_currentIndex)
          if allowNext
            $timeout -> $scope.swiper.unlockSwipeToNext()
            

    _slideTo = (index=0, delay=0) ->
      if $scope.swiper
        $scope.swiper.slideTo index
        $timeout -> 
          $rootScope.$broadcast "$wizardIndexChange", index
          _wizardKeyboardData index

    _focusInput = (target) ->
      $timeout ->
        target.focus()
      , 150

    _blurHandler = (e) ->
      e.preventDefault()
      e.stopPropagation()
      $target = $ e.target
      lastIndex = $scope.wizard.response.schema.slides.length-1
      tabindex = parseInt $target.attr("tabindex")
      if $target.attr("type") is "radio"
        tabindex = parseInt $(e.target).closest("[tabindex]").attr("tabindex")
      else
        tabindex = parseInt $(e.target).attr("tabindex")
      _s = $scope.swiper.container[0].swiper
      if tabindex isnt _s.activeIndex
        _s.previousIndex = tabindex
      return false

    _focusInHandler = (e) ->
      $target = $ e.target
      tabindex = parseInt $target.attr("tabindex")
      if $target.attr("type") is "radio"
        tabindex = parseInt $(e.target).closest("[tabindex]").attr("tabindex")
      else
        tabindex = parseInt $(e.target).attr("tabindex")
      _s = $scope.swiper.container[0].swiper
      _s.activeIndex = tabindex
      _updatePagination tabindex
      _updateNavigation tabindex
      _updateKeyboard $target
      $rootScope.$broadcast "$wizardIndexChange", tabindex
      if tabindex+1 < $scope.wizard.response.schema.slides.length
        $rootScope.$broadcast "$wizardKeyboardData", 
          index: tabindex+1
          slide: $scope.wizard.response.schema.slides[tabindex+1]
    
    _clickHandler = (e) ->
      $target = $ e.target
      tabindex = parseInt $(e.target).closest("[tabindex]").attr("tabindex")
      if $target.attr('type') is "radio" and $scope.isNextAvailable(tabindex)
        $target = $ "[tabindex=#{tabindex+1}]"
        $rootScope.$broadcast "$wizardSlideTo",
          index: tabindex+1
          target: $target

    _keydownHandler = (e) ->
      $target = $ e.target
      altKey = e.altKey
      shiftKey = e.shiftKey
      lastindex = $scope.wizard.response.schema.slides.length - 1
      code = e.which or e.keyCode
      if $target.attr('type') is "radio"
        tabindex = parseInt $target.closest("[tabindex]").attr("tabindex")
      else
        tabindex = parseInt $target.attr("tabindex")
      if code is 16 or code is 17 or code is 18 then return false
      if code is 9 or code is 13
        if altKey then return false 
        if not shiftKey and tabindex is lastindex
          if $scope.validate() then $scope.continue()
        else if shiftKey and tabindex is 0
          $scope.exit()
        else if tabindex >= 0 and tabindex <= lastindex
          if shiftKey
            $target = $ "[tabindex=#{tabindex-1}]"
            $rootScope.$broadcast "$wizardSlideTo",
              index: tabindex-1
              target: $target
          else
            if not $scope.isNextAvailable(tabindex)
              e.preventDefault()
              e.stopPropagation()
              return false
            else
              $target = $ "[tabindex=#{tabindex+1}]"
              $rootScope.$broadcast "$wizardSlideTo",
                index: tabindex+1
                target: $target
        return false
      else
        _updateNavigation tabindex
      return true
    
    _wizardKeyboardData = (index) ->
      if index < $scope.wizard?.response?.schema.slides.length
        $rootScope.$broadcast "$wizardKeyboardData",
          index: index
          slide: $scope.wizard.response.schema.slides[index]

    _loadWizard = debounce ->
      { specialty: s, pack: p, calculator: c } = $stateParams
      $translatePartialLoader.addPart "auth"
      $translatePartialLoader.addPart "wizard-#{s}-#{p}-#{c}"
      NetMedicisService.getWizard "#{s}:#{p}:#{c}", (err, response) ->
        if err then console.debug err
        else
          $scope.wizard.response = response
          $scope.wizard.loaded = true
          $scope.wizard.data = {}
          if $scope.swiper then _slideTo()
    , 250
    
    $scope.options =
      loop: false,
      autoHeight: false,
      speed: 750,
      initialSlide: 0,
      slidesPerView: 1,
      effect: 'slide',
      paginationType: 'custom',
      pagination: '.wizard-footer-pagination',
      paginationClickable: true,
      paginationBulletRender: (index, className) ->
        "<span class='#{className}' index='#{index}'></span>"

    $scope.continue = ->
      if $scope.validate()
        $rootScope.wizardInput = null
        $rootScope.wizardOutput = null
        if typeof $scope.wizard.response.method isnt "function"
          throw new Error
        $rootScope.wizardInput = $scope.wizard.data
        if $scope.wizard.response.display then $rootScope.wizardDisplay = $scope.wizard.response.display
        $scope.wizard.response.method $scope.wizard.data, (err, out) ->
          if !err
            $rootScope.wizardOutput = out 
            $ionicHistory.clearCache().then ->
              $scope.go "app.calculator.output", $stateParams
          else throw new Error err
      
    $scope.exit = ->
      $scope.go "app.index"

    $scope.next = ->
      $scope.swiper.slideNext()

    $scope.previous = ->
      $scope.swiper.slidePrev()

    $scope.isNextAvailable = (index) ->
      index ?= $scope.swiper.activeIndex
      slide = $scope.wizard?.response?.schema?.slides?[index]
      value = $scope.wizard.data[slide.name]
      return value isnt '' and value isnt null and value isnt undefined
    
    $scope.validate = ->
      if $scope.finished then return true
      isValid = true
      $scope.wizard.response.schema.slides.map (slide, i) ->
        if not isValid then return false
        isValid = $scope.isNextAvailable(i)
      isValid
        
    $scope.load = ->
      if $state.current.name isnt "app.tab.output" and $state.current.name isnt "app.wizard"
        $scope.wizard = loaded: false, data: {}, response: null
      if $state.current.name is "app.wizard" 
        if not $scope.wizard.loaded
          _loadWizard()
        else
          _slideTo()
        
module.exports = AppWizardController