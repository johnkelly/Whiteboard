window.bresenham_line_algorithm = (x1, y1, x2, y2, color, context, lineWidth) ->
  steep = Math.abs(y2-y1) > Math.abs(x2-x1)

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

  lineThickness = (5 - Math.sqrt((x2 - x1) * (x2- x1) + (y2 - y1) * (y2 - y1)) / 10) * lineWidth

  if lineThickness < 1
    lineThickness = 1

  for x in [x1...x2] by 1
    if steep
      context.fillRect(y, x, lineThickness , lineThickness)
    else
      context.fillStyle = color
      context.fillRect(x, y, lineThickness , lineThickness)

    error += de

    if error >= 0.5
      y += yStep
      error -= 1.0