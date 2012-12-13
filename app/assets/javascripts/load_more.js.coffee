$(document).ready ->
  $("a.hook").bind "inview", (e, visible) ->
    $.getScript $(this).attr("href")  if visible
  $("a.hook-topic").bind "inview", (e, visible) ->
    $.getScript $(this).attr("href")  if visible

  $("a.hook-link-comments").bind "inview", (e, visible) ->
    $.getScript $(this).attr("href")  if visible

