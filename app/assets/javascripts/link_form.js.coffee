$(document).ready ->
  $("#submit_button").hide()
  $("textarea#complete_url").autosize()
  $('textarea#comment_text').autosize();  

$("#complete_url").bind "input propertychange", ->
  $("#submit_button").hide()  if @value.length is 0

$("#complete_url").keyup (evt) ->
  if evt.keyCode is 32
    hi = $("#complete_url").val()
    $("#submit_button").show()  if hi?

$("#complete_url").bind "paste", (e) ->
  setTimeout (->
    h = $("#complete_url").val()
    $("#submit_button").show()  if h?
  ), 500
