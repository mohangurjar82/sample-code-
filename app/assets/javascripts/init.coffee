$ ->
  # enable hires images
  altair_helpers.retina_images()
  
  # fastClick (touch devices)
  if(Modernizr.touch)
    FastClick.attach(document.body)

$(document)
  .on('ready page:load',(event) ->
    UIkit.init()
    altair_page_onload.init()
    altair_main_header.init()
    altair_main_sidebar.init()
    altair_secondary_sidebar.init()
    altair_top_bar.init()
    altair_page_heading.init()
    altair_md.init()
    altair_forms.init()
    altair_helpers.truncate_text($('.truncate-text'))
    altair_helpers.full_screen()
  )
