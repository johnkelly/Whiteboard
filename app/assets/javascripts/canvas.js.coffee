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
        bresenham_line_algorithm(point[0], point[1], point[2], point[3], point[4], context)
    )
    color = "#FFFFFF"
    context.fillStyle = color
    context.fillRect(0,0,canvas.width,canvas.height)

    color = "#000000"
    context.fillStyle = color

    #Prevent Right Click menu on Canvas
    $('body').on('contextmenu', 'canvas', (e) ->
      false
    )

    canvas.onmousedown = (e) ->
      if active_tool
        painting = true
        context.fillStyle = color
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

        pointsToDraw.push([x1, y1, x2, y2, color])
        handleMouseMove(mouseX, mouseY, x1, y1, x2, y2, color)

    handleMouseMove = (mouseX, mouseY, x1, y1, x2, y2, color) ->
      bresenham_line_algorithm(x1, y1, x2, y2, color, context)
      lastX = mouseX
      lastY = mouseY

    window.setInterval(
      ->
        if pointsToDraw.length
          channel.trigger("client-mouse-moved", { pointsToDraw: pointsToDraw })
          pointsToDraw = [] if pusher.connection.state is "connected"
      250
    )

    $('[data-behavior~=pen_tool]').live 'click', ->
      active_tool = "pen_tool"

    $('[data-behavior~=erase_tool]').live 'click', ->
      active_tool = "erase_tool"
      color = "#FFFFFF"

    $('[data-behavior~=color_picker]').live 'change', ->
      if active_tool is "erase_tool"
        active_tool = false
      color = $(@).val()

    $('[data-behavior~=save_tool]').live 'click', ->
      $('#canvas_save').css('visibility', 'visible')
      image_data = canvas.toDataURL("image/png")
      url = $(@).data('url')
      $.post(url, { image_data: image_data })


