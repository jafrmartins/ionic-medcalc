{ dasherize } = require 'underscore.string'

module.exports = ->
  return (str) ->
    return dasherize(str).replace(/-/g, '_').toUpperCase()