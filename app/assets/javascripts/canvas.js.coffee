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

      steep = (Math.abs(y2-y1) > Math.abs(x2-x1))
      if steep
        x = x1
        x1 = y1
        y1 = x

        y = y2
        y2 = x2
        x2 = y
      if x1 > x2
        x = x1
        x1 = x2
        x2 = x

        y = y1
        y1 = y2
        y2 = y

      dx = x2 - x1
      dy = Math.abs(y2 - y1)
      error = 0
      de = dy / dx
      yStep = -1
      y = y1

      if y1 < y2
        yStep = 1

      lineThickness = 5 - Math.sqrt((x2 - x1) * (x2- x1) + (y2 - y1) * (y2 - y1)) / 10

      if lineThickness < 1
        lineThickness = 1

      for x in [x1...x2] by 1
        if steep
          context.fillRect(y, x, lineThickness , lineThickness)
        else
          context.fillStyle = "#000000"
          context.fillRect(x, y, lineThickness , lineThickness)

        error += de

        if error >= 0.5
          y += yStep
          error -= 1.0

      lastX = mouseX
      lastY = mouseY