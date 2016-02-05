$ ->
  # enable hires images
  altair_helpers.retina_images()
  
  # fastClick (touch devices)
  if(Modernizr.touch)
    FastClick.attach(document.body)

$(document)
  .on('ready page:load',(event) ->
    UIkit.init()
  )
