module.exports = 

  'otherwise': 
    url: '/auth'
      
  'auth':
    url: '/auth'
    controller: 'AuthController'
    templateUrl: 'partials/auth.html'
    
  'app':
    url: '/app'
    abstract: true
    controller: 'AppController'
    templateUrl: 'partials/app.html'

  'app.index':
    url: '/index'
    views:
      'content':
        controller: 'AppIndexController'
        templateUrl: 'partials/app-index.html'

  'app.bibliography':
    url: '/bibliography'
    views:
      'content':
        controller: 'AppBibliographyController'
        templateUrl: 'partials/app-bibliography.html'
  
  'app.wizard':
    url: '/wizard/:specialty/:pack/:calculator'
    views:
      'content':
        controller: 'AppWizardController'
        templateUrl: 'partials/app-wizard.html'

  'app.tab':
    abstract: true
    url: '/tab/:specialty/:pack/:calculator'
    views:
      'content':
        controller: 'AppTabController'
        templateUrl: 'partials/app-tab.html'
  
  'app.tab.output':
    url: '/output'
    views:
      'output':
        controller: 'AppTabOutputController'
        templateUrl: 'partials/app-tab-output.html'
  
  'app.tab.about':
    url: '/about'
    views:
      'about':
        controller: 'AppTabAboutController'
        templateUrl: 'partials/app-tab-about.html'
