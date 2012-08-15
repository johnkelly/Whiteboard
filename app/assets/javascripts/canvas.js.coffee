jQuery ->
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

  channel.bind('client-mouse-moved', (data) ->
    bresenham_line_algorithm(data.x1, data.y1, data.x2, data.y2, context)
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
    if enableHandler && painting
      handleMouseMove(e, @offsetLeft, @offsetTop)
      enableHandler = false

  handleMouseMove = (e, offsetLeft, offsetTop) ->
    mouseX = e.pageX - offsetLeft
    mouseY = e.pageY - offsetTop

    x1 = mouseX
    x2 = lastX
    y1 = mouseY
    y2 = lastY

    bresenham_line_algorithm(x1, y1, x2, y2, context)
    channel.trigger("client-mouse-moved", { x1:mouseX, y1: mouseY, x2: lastX, y2: lastY })
    lastX = mouseX
    lastY = mouseY

  timer = window.setInterval(
    ->
      enableHandler = true
    120
  )
