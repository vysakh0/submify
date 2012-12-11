//= require jquery.ui.autocomplete


$("#search_input").autocomplete(
  source: "/autocomplete"
  minLength: 2 
  select: (event, ui) ->
    document.location = ui.item.url
).data("autocomplete")._renderItem = (ul, item) ->
  $("<li></li>").data("item.autocomplete", item).append("<a>" + "<img src='" + item.imgsrc + "' />" + " "+ item.label + item.category + "</a>").appendTo ul

