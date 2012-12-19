//= require jquery.ui.autocomplete


$("#search_input").autocomplete(
  source: "/autocomplete"
  minLength: 2 
  select: (event, ui) ->
    document.location = ui.item.url
).data("autocomplete")?._renderItem = (ul, item) ->
  $("<li></li>").data("item.autocomplete", item).append("<a>" + "<span class='auto-img-nav'>" +  "<img src='" + item.imgsrc + "' />" + "</span><span class='auto-label'>"+ item.label + "</span><span class='auto-category'>" + item.category + "</span></a>").appendTo ul

