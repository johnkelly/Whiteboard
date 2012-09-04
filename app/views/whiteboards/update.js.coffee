saved_message = $('#canvas_save')
saved_message.removeClass("alert-info").addClass("alert-success")
saved_message.text("Your white board was succcessfully saved to the cloud.")
saved_message.fadeOut(10000, ->
  saved_message.show().css(
    visibility: "hidden"
  )
  saved_message.text("Saving...")
  saved_message.removeClass("alert-success").addClass("alert-info")
)