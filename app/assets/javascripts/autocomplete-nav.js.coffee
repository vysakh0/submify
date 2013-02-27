###
Submify - Dashboard of web and web activity
Copyright (C) 2013 Vysakh Sreenivasan <support@submify.com>

This file is part of Submify.

Submify is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

Submify is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with Submify.  If not, see <http://www.gnu.org/licenses/>.
###
//= require jquery.ui.autocomplete


$("#search_input").autocomplete(
  source: "/autocomplete"
  minLength: 2 
  select: (event, ui) ->
    document.location = ui.item.url
).data("autocomplete")?._renderItem = (ul, item) ->
  $("<li></li>").data("item.autocomplete", item).append("<a>" + "<span class='auto-img-nav'>" +  "<img src='" + item.imgsrc + "' />" + "</span><span class='auto-label'>"+ item.label + "</span><span class='auto-category'>" + item.category + "</span></a>").appendTo ul

