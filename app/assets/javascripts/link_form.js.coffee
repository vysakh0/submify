$(document).ready ->
  $("#submit_button").hide()
  $(".link-topic-tag").hide()
  $('#link_c_text').hide();  
  $("textarea#complete_url").autosize()
  $('textarea#comment_text').autosize();  
  $('textarea#user_description').autosize();  
  $('textarea#topic_description').autosize();  
  $('textarea#link_c_text').autosize();  

$("#comment_text").live "click", (event) ->
  $("textarea#comment_text").autosize()


$("#complete_url").bind "input propertychange", ->
  $("#submit_button").hide()  if @value.length is 0
  $(".link-topic-tag").hide()  if @value.length is 0
  $("#link_c_text").hide()  if @value.length is 0

$("#complete_url").keyup (evt) ->
  if evt.keyCode is 32
    hi = $("#complete_url").val()
    $("#submit_button").show()  if hi?
    $(".link-topic-tag").show()  if hi?

$("#complete_url").bind "paste", (e) ->
  setTimeout (->
    h = $("#complete_url").val()
    $("#submit_button").show()  if h?
    $(".link-topic-tag").show()  if h?
    $("#link_c_text").show()  if h?
  ), 500
