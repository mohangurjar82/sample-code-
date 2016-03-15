jQuery(document).ready ->
  $('.search-icon').click ->
    $('.search-bar').css('top', '48px')

  $('#page_content_inner').click ->
      $('.search-bar').css('top', '-53px')
