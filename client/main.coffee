updateMessages = (message)->
  _messages = Session.get "messages"
  _messages.push message
  Session.set "messages", _messages

Meteor.startup ->
  Session.setDefault "messages", []
  Session.setDefault "bridge", null
  Session.set "isBridge", false

$(document).ready ->
  console.log "session is a: ", typeof Session
  for k,v of Session
    console.log k
    console.log v
  updateMessages "document is ready, binding WebViewJavascriptBridgeReady"
  $(document).bind "WebViewJavascriptBridgeReady", (event)->
    for key,value of event
      k=""+key
      v = ""+value
      updateMessages k
      updateMessages v
    bridge = null
    if event.bridge?
      Session.set "isBridge", true
      bridge = event.bridge
      updateMessages bridge
      bridge.init "yo yo yo this is some data fool", (data, cb)->
        cb(data)
        bridge.send {"userDidLogin": "ANDREW LOGGED IN"}, (res)->
          updateMessages(res)
      bridge.userDidLogin("ANDREW LOGGED ")
    else if window.bridge?
      Session.set "isBridge", true
      bridge = window.bridge
      updateMessages bridge
      bridge.init (data, cb)->
        cb(data)
        bridge.send {"userDidLogin": "ANDREW LOGGED IN"}, (res)->
          updateMessages(res)
      bridge.userDidLogin("ANDREW LOGGED ")
    Session.set "bridge", bridge




Template.hello.helpers
  'greeting': ->
    console.log "greeting"

Template.bridge_status.helpers
  'isbridge': -> if Session.get("bridge")? then "BRIDGE IS WORKING" else "BRIDGE ISNT WORKING"


Template.hello.events =
  'click #send': (evt)->
    evt.preventDefault()
    if Session.get "isBridge" then updateMessages "you clicked a button and bridge was defined"
    else updateMessages "no dice sir... bridge isnt defined..."


Template.MESSAGES.helpers
  'messages': ->
    Session.get 'messages'
