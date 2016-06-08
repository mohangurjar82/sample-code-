jQuery(document).ready ->
  return if $('.subcribed-this-product').length > 0

  setTimeout(
    ()->
      player.stop() if typeof(player) == "object"
      $('#purchase-modal').modal('show')
    30000
  )

  $('#purchase-modal').on('hidden.bs.modal', ->
    document.location.href = $('.subscribe-btn').attr('href')
  )