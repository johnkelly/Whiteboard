clear_canvas = (canvas, context) ->
  set_canvas_color("#FFFFFF", context)
  context.fillRect(0,0,canvas.width,canvas.height)

draw_saved_image_onto_canvas = (context) ->
  saved_image = new Image()
  saved_image.crossOrigin = "anonymous"
  saved_image.onload = ->
    context.drawImage(@, 0, 0)
  saved_image.src = $('canvas').data('url')

set_canvas_color = (color, context) ->
  context.fillStyle = color
  color

prevent_right_click_on_canvas = ->
  $('body').on('contextmenu', 'canvas', (e) ->
    false
  )

jQuery ->
  if $('canvas').length > 0
    pusher = new Pusher($('meta[name="pusher-key"]').attr('content'))
    channel = pusher.subscribe('private-drawing')

    canvas = $('canvas').get(0)
    canvas.width = 980
    canvas.height = 650
    enableHandler = false

    context = canvas.getContext('2d')
    painting = false
    lastX = 0
    lastY = 0
    lineThickness = 1
    pointsToDraw = []
    active_tool = false

    channel.bind('client-mouse-moved', (data) ->
      for point in data.pointsToDraw
        bresenham_line_algorithm(point[0], point[1], point[2], point[3], point[4], context, point[5])
    )
    clear_canvas(canvas, context)
    draw_saved_image_onto_canvas(context)
    color = set_canvas_color("#000000", context)
    last_color = color

    prevent_right_click_on_canvas()

    canvas.onmousedown = (e) ->
      if active_tool
        painting = true
        set_canvas_color(color, context)
        lastX = e.pageX - @offsetLeft
        lastY = e.pageY - @offsetTop

    document.onmouseup = (e) ->
      if painting
        painting = false

    canvas.onmouseout = (e) ->
      if painting
        painting = false

    canvas.onmousemove = (e) ->
      if painting
        mouseX = e.pageX - @offsetLeft
        mouseY = e.pageY - @offsetTop

        x1 = mouseX
        x2 = lastX
        y1 = mouseY
        y2 = lastY

        pointsToDraw.push([x1, y1, x2, y2, color, context.lineWidth])
        handleMouseMove(mouseX, mouseY, x1, y1, x2, y2, color)

    handleMouseMove = (mouseX, mouseY, x1, y1, x2, y2, color) ->
      bresenham_line_algorithm(x1, y1, x2, y2, color, context, context.lineWidth)
      lastX = mouseX
      lastY = mouseY

    window.setInterval(
      ->
        if pointsToDraw.length
          channel.trigger("client-mouse-moved", { pointsToDraw: pointsToDraw })
          pointsToDraw = [] if pusher.connection.state is "connected"
      250
    )

    $('[data-behavior~=pen_tool]').on 'click', (e) ->
      e.preventDefault()
      active_tool = "pen_tool"
      $('a').removeClass('selected')
      $(@).addClass('selected')

      color = last_color

    $('[data-behavior~=erase_tool]').on 'click', (e) ->
      e.preventDefault()
      active_tool = "erase_tool"
      $('a').removeClass('selected')
      $(@).addClass('selected')

      last_color = color
      color = "#FFFFFF"

    $('[data-behavior~=brush_size_tool]').on 'change', ->
      context.lineWidth = $(@).val()

    $('[data-behavior~=color_picker]').on 'change', ->
      if active_tool is "erase_tool"
        active_tool = false
      color = $(@).val()
      last_color = color

    $('[data-behavior~=erase_all_tool]').on 'click', (e) ->
      e.preventDefault()
      if confirm "Are you sure?"
        context.save()
        context.setTransform(1,0,0,1,0,0)
        context.clearRect(0, 0, canvas.width, canvas.height)
        context.restore()
        clear_canvas(canvas, context)

    $('[data-behavior~=save_tool]').on 'click', ->
      $('#canvas_save').css('visibility', 'visible')
      image_data = canvas.toDataURL("image/png")
      url = $(@).data('url')
      $.ajax(
        type: 'PUT'
        url: url
        data: { image_data: image_data }
      )

