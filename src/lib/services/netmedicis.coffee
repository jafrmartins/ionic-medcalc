_output = null
_keys = {}
_eval = (str) -> eval(str).pop()

class NetMedicisService

  constructor: (
    @$http,
    @$rootScope,
    @settings,
    @CryptoService
  ) ->
    _keys = @$rootScope?.credentials?.keys
    @$rootScope.$on "$authCredentials", (e, d)->
      _keys = d.keys
  
  addPermissions: (pack, done) ->
    @$http
      method: "PUT"
      url: "#{@settings.netmedicis.endpoint}/scope/add/#{pack.id}"
    .success (res, status, headers, config) =>
      if status is 200
        done null, res
    .error (res, status, headers, config) =>
      done status, null

  getWizard: (scope, done) ->
    [ s, p, m ] = scope.split ":"
    if !s or !p or !m then return done "invalid scope: #{scope}", null
    if !_keys[scope] then return done "no key for scope #{scope}", null
    
    @$http
      method: "GET"
      url: "#{@settings.offline.endpoint}/#{s}/#{p}/#{m}.json"
    .success (res, status, headers, config) =>
      if status is 200 and typeof res.method is "string"
        try
          @CryptoService.decipher res.method, _keys[scope]
        catch err
          console.debug "#{@settings.offline.endpoint}/#{s}/#{p}/#{m}.json", err
          return done err, null
        res.method = _eval @CryptoService.decipher res.method, _keys[scope]
        done null, res
    .error (res, status, headers, config) =>
      done status, null

module.exports = NetMedicisService