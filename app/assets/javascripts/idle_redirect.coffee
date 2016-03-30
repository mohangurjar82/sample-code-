jQuery(document).ready ->
  $(document).idle
    onIdle: ->
      unless document.fullScreen || document.webkitIsFullScreen || document.mozFullScreen
        document.location.href = '/'
        return
    idle: 20*60*1000 #20 minutes