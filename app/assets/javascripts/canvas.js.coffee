jQuery ->
  canvas = $('canvas').get(0)
  canvas.width = 800
  canvas.height = 500

  context = canvas.getContext('2d')
  painting = false
  lastX = 0
  lastY = 0
  lineThickness = 1

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

      bresenham_line_algorithm(x1, y1, x2, y2, context)

      lastX = mouseX
      lastY = mouseY
