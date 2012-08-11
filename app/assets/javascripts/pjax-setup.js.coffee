jQuery ->
  $('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax])').pjax('[data-pjax-container]')
  $('[data-pjax-container]').bind("start.pjax", ->
    $('[data-pjax-container]').hide 0
  ).bind "end.pjax", ->
    $('[data-pjax-container]').fadeIn 500
