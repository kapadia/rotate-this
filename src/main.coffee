
getSubject = ->
  console.log 'getSubject'

postClassification = ->
  console.log 'postClassification'

$(document).ready ->
  console.log 'ready'
  $.getScript("lib/zooniverse.js", ->
    
    api = new zooniverse.Api
      project: 'rotate-this'
      host: "https://dev.zooniverse.org"
      path: '/proxy'
    
    topBar = new zooniverse.controllers.TopBar
    topBar.el.appendTo 'body'
  )