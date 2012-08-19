jQuery ->
  if $('canvas').length > 0
    pusher = new Pusher('337af4c021caaef28ff9')
    channel = pusher.subscribe('private-drawing')

    canvas = $('canvas').get(0)
    canvas.width = 800
    canvas.height = 500
    enableHandler = false

    context = canvas.getContext('2d')
    painting = false
    lastX = 0
    lastY = 0
    lineThickness = 1
    pointsToDraw = []

    channel.bind('client-mouse-moved', (data) ->
      for point in data.pointsToDraw
        bresenham_line_algorithm(point[0], point[1], point[2], point[3], context)
    )

    context.fillStyle = "#FFFFFF"
    context.fillRect(0,0,canvas.width,canvas.height)

    canvas.onmousedown = (e) ->
      painting = true
      context.fillStyle = "#000000"
      lastX = e.pageX - @offsetLeft
      lastY = e.pageY - @offsetTop

    canvas.onmouseup = (e) ->
      painting = false

    canvas.onmousemove = (e) ->
      if painting
        mouseX = e.pageX - @offsetLeft
        mouseY = e.pageY - @offsetTop

        x1 = mouseX
        x2 = lastX
        y1 = mouseY
        y2 = lastY

        pointsToDraw.push([x1, y1, x2, y2])
        handleMouseMove(mouseX, mouseY, x1, y1, x2, y2)

    handleMouseMove = (mouseX, mouseY, x1, y1, x2, y2) ->
      bresenham_line_algorithm(x1, y1, x2, y2, context)
      lastX = mouseX
      lastY = mouseY

    timer = window.setInterval(
      ->
        channel.trigger("client-mouse-moved", { pointsToDraw: pointsToDraw })
        pointsToDraw = [] if pusher.connection.state is "connected"
      500
    )
