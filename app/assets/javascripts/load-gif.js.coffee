$ ->
  # hide it initially.
  # show on any Ajax event.
  $(".loading-indicator").hide().ajaxStart(->
    $(this).show()
  ).ajaxStop ->
    $(this).hide() # hide it when it is done.


