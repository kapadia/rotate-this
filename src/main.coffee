
User = null
subject1 = null
subject2 = null
subjects = null
comparison = null
currentSubjects = null

getSubject = ->
  
  $.get("gettwo", (data)->
    if Math.random() < 0.5
      s1 = data[0]
      s2 = data[1]
    else
      s2 = data[0]
      s1 = data[1]
    
    subject1.attr("src", s1.location)
    subject1.attr("data-id", s1._id)
    
    subject2.attr("src", s2.location)
    subject2.attr("data-id", s2._id)
    
    currentSubjects = data
    comparison.removeClass("hide")
    
    subjects.on("click", onClassification)
  )

postClassification = ->
  console.log 'postClassification'

onClassification = ->
  subjects.off("click", onClassification)
  
  el = $(this).find("img.subject")
  id = el.attr("data-id")
  
  s1 = currentSubjects.shift()
  s2 = currentSubjects.shift()
  
  classification = {
    subject1: s1["_id"]
    subject2: s2["_id"]
    selected: id
    expert_id: User.current.id
    expert_name: User.current.name
  }
  
  $.post("classification", classification)
    .done( ->
      getSubject()
    )

setupLogin = ->
  api = new zooniverse.Api
    project: 'rotate-this'
    host: "https://dev.zooniverse.org"
    path: '/proxy'
  
  topBar = new zooniverse.controllers.TopBar
  topBar.el.appendTo 'body'
  
  User.on "change", ->
    if User.current
      getSubject()
    else
      comparison.addClass("hide")
  
  unless User.current
    zooniverse.controllers.loginDialog.show()

$(document).ready ->
  
  # Cache DOM elements
  subject1 = $("#subject1")
  subject2 = $("#subject2")
  comparison = $("#comparison")
  subjects = $("div.image")
  
  $.getScript("lib/zooniverse.js", ->
    User = zooniverse.models.User
    setupLogin()
  )