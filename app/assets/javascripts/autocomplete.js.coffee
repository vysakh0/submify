
//= require jquery.ui.autocomplete
$ ->
  $("#person_name").autocomplete 

       source: "/autocomplete" 
       select: (event, ui) ->
          selectedObj = ui.item
          window.location.href = selectedObj.url

  $("#topic_name").autocomplete source: "/autocomplete_topic" 
