$("#spinner").ajaxStart(->
  $(this).fadeIn "fast"
).ajaxStop ->
  $(this).stop().fadeOut "fast"

