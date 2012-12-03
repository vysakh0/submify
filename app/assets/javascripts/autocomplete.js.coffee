
//= require jquery.ui.autocomplete
$ ->
  $("#person_name").autocomplete source: "/autocomplete" 
  $("#topic_name").autocomplete source: "/autocomplete_topic" 
