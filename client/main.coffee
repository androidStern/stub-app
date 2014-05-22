connectWebViewJavascriptBridge = (callback)->
  if window.WebViewJavascriptBridge then callback(WebViewJavascriptBridge)
  else document.addEventListener 'WebViewJavascriptBridgeReady', (-> callback(WebViewJavascriptBridge)), false

connectWebViewJavascriptBridge (bridge)->
  bridge.init (message, responseCallback)->

updateMessages = (message)->
  _messages = Session.get "messages"
  _messages.push message
  Session.set "messages", _messages

Meteor.startup ->
  Session.setDefault "messages", []

Template.hello.events =
  'click #send': (evt)->
    evt.preventDefault()
    updateMessages "called userDidLogin"
    window.WebViewJavascriptBridge.callHandler 'userDidLogin', "andrewstern", (data)->
      updateMessages(data)

Template.MESSAGES.helpers
  'messages': ->
    Session.get 'messages'
