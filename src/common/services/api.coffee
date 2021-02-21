_serializeParams = (obj={}) ->
  if obj.attributes?.length
    obj.attributes = attributes.join ","
  if obj.where
    obj.where = JSON.stringify obj.where
  obj

class ApiResource
  
  constructor: (@$http, @settings, url) ->
    @url = "#{@settings.endpoint}/#{url}.json"
  
  list: (options, done) ->
    if typeof options is "function"
      done = options
      options = {}
    _params = _serializeParams options
    @$http
      method: "GET"
      url: "#{@url}"
      params: _params
    .success (data) ->
      done null, data
    .error (error) ->
      done error, null
  
  get: (options, done) ->
    if !options.id
      throw new Error "invalid id"
    delete options.id
    _params = _serializeParams options
    @$http
      method: "GET"
      url: "#{@url}/#{options.id}"
      params: _params
    .success (data) ->
      done null, data
    .error (error) ->
      done error, null
      
class ApiService
  constructor: (@$http, settings) ->
    @settings = settings
  resource: (url) ->
    new ApiResource @$http, @settings.api, url
    
module.exports = ApiService