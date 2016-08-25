#$(document).on 'page:change', ->
#$(document).ready ->
#$(document).on 'turbolinks:load', 'page:change', ->
#  FB.init({ status: true, cookie: true, xfbml: true });

$ ->
  loadFacebookSDK()
  bindFacebookEvents() unless window.fbEventsBound
	console.log 'everytime'

bindFacebookEvents = ->
  $(document)
    .on('page:fetch', saveFacebookRoot)
    .on('page:change', restoreFacebookRoot)
    .on('page:load', ->
      FB?.XFBML.parse()
    )
  @fbEventsBound = true

saveFacebookRoot = ->
  if $('#fb-root').length
    @fbRoot = $('#fb-root').detach()

restoreFacebookRoot = ->
  if @fbRoot?
    if $('#fb-root').length
      $('#fb-root').replaceWith @fbRoot
    else
      $('body').append @fbRoot

loadFacebookSDK = ->
  window.fbAsyncInit = initializeFacebookSDK
  $.getScript("//connect.facebook.net/ja_JP/sdk.js#xfbml=1")

initializeFacebookSDK = ->
  FB.init
#		version: 'v2.7'
    appId  : '1721451128113160"'
    status : true
    cookie : true
    xfbml  : true

