
//= require jquery.ui.autocomplete
$ ->
  $("#person_name").autocomplete 

       source: "/autocomplete" 
       select: (event, ui) ->
          selectedObj = ui.item
          window.location.href = selectedObj.url
  
  $("#topic_name").autocomplete(
  	source: "/autocomplete_topic"
  	minLength: 2 
  ).data("autocomplete")._renderItem = (ul, item) ->
  	$("<li></li>").data("item.autocomplete", item).append("<a>" + "<img src='" + item.imgsrc + "' />" + item.label + "</a>").appendTo ul
