$('#whiteboards').append('<%= j render partial: "whiteboards/whiteboard", collection: @whiteboards %>')
<% if @whiteboards.next_page %>
$('.pagination').replaceWith('<%= j will_paginate(@whiteboards) %>')
<% else %>
$('.pagination').remove()
<% end %>