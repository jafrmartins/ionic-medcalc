module.exports = ($templateCache, $templateRequest, $compile) ->
  restrict: "E"
  scope: "="
  link: (scope, elem, attrs) ->
    template = attrs.template
    if !template then throw new Error "invalid template"
    if html = $templateCache.get template
      if typeof html is "string"
        template = angular.element html
        elem.append template
        $compile(template)(scope)
      else
        html.then (response) ->
          template = angular.element response.data
          elem.append template
          $compile(template)(scope)
    else
      $templateRequest(template).then (html) ->
        template = angular.element html
        elem.append template
        $compile(template)(scope)
      , -> throw new Error "invalid template"
      