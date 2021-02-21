class AuthService

  constructor: (
    @settings, 
    @$http, 
    @$base64, 
    @$rootScope,
    @CryptoService
  ) ->
  
  setCredentials: (credentials) ->
    @username = credentials.username
    @password = credentials.token
    @$http.defaults.headers.common['Authorization'] = @getAuthHeader()
    
  getCredentials: ->
    username: @username,
    password: @password

  clearCredentials: ->
    @username = @password = null

  isAnonymous: ->
    return !@username || !@password

  getAuthHeader: ->
    credentials = @getCredentials()
    return 'Basic ' + @$base64.encode(
      "#{credentials.username}:#{credentials.password}"
    )
  
  credentials: (storage, done) ->
    if typeof storage is "function" and typeof done is "undefined"
      done = storage
    else if typeof storage is "object" and storage.credentials and storage.token
      try
        res = JSON.parse @CryptoService.decipher storage.credentials, storage.token
        @$rootScope.$broadcast "$authCredentials", res
        return done null, res
      catch err
        return done err, null
    @$http
      method: "GET",
      url:  "#{@settings.auth.endpoint}/credentials"
    .success (res, status, headers, config) =>
      if status is 200
        try
          @$rootScope.$broadcast "$authCredentials", res 
          done null, res
        catch err
          done err, null
    .error (res, status, headers, config) =>
      done status, null

  register: (data, done) ->
    @$http
      method: "POST",
      url: "#{@settings.auth.endpoint}/register",
      data: data 
    .success (res, status, headers, config) ->
      if status is 200 then return done null, res
    .error (res, status, headers, config) ->
      done status, null
      
  login: (data, done) ->
    if data.provider is "facebook"
      @$http
        method: "POST",
        url: "#{@settings.auth.endpoint}/#{data.provider}",
        data: { token: data.token } 
      .success (res, status, headers, config) ->
        if status is 200 then return done null, res
      .error (res, status, headers, config) ->
        done status, null
    else
      @$http
        method: "POST",
        url: "#{@settings.auth.endpoint}/login",
        data: { email: data.email, password: data.password } 
      .success (res, status, headers, config) ->
        if status is 200 then return done null, res
      .error (res, status, headers, config) ->
        done status, null

  logout: (done) ->
    @$http
      method: "POST",
      url: "#{@settings.auth.endpoint}/logout" 
    .success (res, status, headers, config) ->
      if status is 200 then return done null, res
    .error (res, status, headers, config) ->
      done status, null

module.exports = AuthService