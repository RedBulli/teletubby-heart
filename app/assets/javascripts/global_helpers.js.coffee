class @Helpers

  getChannels: () ->
      $.ajax
        url: '/'
        dataType: 'html'
        async: true
        success: (data) ->
          $("body").load()

  getParameters: () ->
      params_arr = window.location.search.substr(1)
      params_arr = params_arr.split("&")
      params = {}
      i = 0

      while i < prmarr.length
        tmparr = prmarr[i].split("=")
        params[tmparr[0]] = tmparr[1]
        i++
      return params

  getParameterByName: (key) ->
      params_arr = window.location.search.substr(1)
      params_arr = params_arr.split("&")
      params = {}
      i = 0

      while i < params_arr.length
        tmparr = params_arr[i].split("=")
        params[tmparr[0]] = tmparr[1]
        i++
        if tmparr[0] == key
          return tmparr[1]
      return false

  changeUrlParam: (key, new_value) ->
      req = new RegExp key+"=\\S", 'g'
      parameter = "&"+key+"="+new_value
      if window.location.search.match(req) == null
        window.location.search + parameter
      else
        window.location.search.replace(req, key+"="+new_value)

  getCurrentPage: () ->
    current_page = if @getParameterByName("page") then parseInt(@getParameterByName("page")) else 1

  enableFullScreen: (container) ->
    elem = document.getElementById(container.toString())
    screenfull.request elem  if screenfull.enabled

    screenfull.onchange = ->
      if screenfull.isFullscreen
      else
        $.ajax
          url: '/'
          dataType: 'html'
          async: true
          success: (data) ->
            $("#content").html(data)






  show_error: (error_msg) ->
    if $("body").find("#error_msg").length == 0
      $("body").append(@.error_message(error_msg))
      $("#error_msg").lightbox_me()

  error_message: (error_msg) ->
    return '<div id="error_msg" class="error_box"><h1 class="error_msg">Problems with connection, contact administrator</h1></br>
            <h3 class="error_msg">error with channel id ' + error_msg + '</h3></div>'





