$(document).ready ->
  $("a.kooh").bind "inview", (e, visible) ->
    $.getScript $(this).attr("href")  if visible

  $("a.hook-user-commented").bind "inview", (e, visible) ->
    $.getScript $(this).attr("href")  if visible

