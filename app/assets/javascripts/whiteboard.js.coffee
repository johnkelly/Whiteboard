infinite_scrolling_pagination = ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next_page a').attr('href')
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').text("Fetching more whiteboards...")
        $.getScript(url)
    $(window).scroll()

jQuery ->
  infinite_scrolling_pagination()

$(document).bind('page:change', ->
  infinite_scrolling_pagination()
)
