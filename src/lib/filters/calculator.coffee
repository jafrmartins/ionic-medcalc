module.exports = ($filter) ->
  return (calcs, q) ->
    
    _t = $filter('translate')
    q = angular.lowercase(q) || ''
    
    if calcs
      calcs.filter (calc) ->
        if calc.isSpecialtyTitle
          specialty = angular.lowercase _t calc.title
          if specialty.indexOf(q) isnt -1
            return true
        else  
          title = angular.lowercase _t calc.title
          description = angular.lowercase _t calc.description
          if title.indexOf(q) isnt -1
            return true
          if description.indexOf(q) isnt -1
            return true
          bibs = calc.bibliography.map (t) -> 
            bib = angular.lowercase _t t.title
            if bib.indexOf(q) isnt -1
              return true
            return false
          hasBib = false
          bibs.map (b) -> if b then hasBib = true
          if hasBib then return true
          tags = calc.tags.map (t) -> 
            tag = angular.lowercase _t t.title
            if tag.indexOf(q) isnt -1
              return true
            return false
          hasTag = false
          tags.map (t) -> if t then hasTag = true
          if hasTag then return true else return false