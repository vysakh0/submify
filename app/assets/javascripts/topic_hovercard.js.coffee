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
jQuery ->
  topic_hovercards = (object) ->
    id = "topic_hovercard_#{$(object).attr("data-hovercard")}"
    if not $("#"+id).length
      $("body").append("<div id='#{id}' class='topic_hovercard'></div>")
    $(object).tooltip
      tipClass: 'topic_hovercard'
      effect: 'slide'
      position: 'bottom center'
      delay: 500
      tip: $("#"+id)
      predelay: 500
      onBeforeShow: () =>
        if not $("#"+id).hasClass("loaded")
          $.ajax
            url: "/topics/#{$(object).attr("data-hovercard")}/hovercard"
            type: 'GET'
            dataType: 'html'
            success: (data) ->
              $("#"+id).addClass("loaded").html(data)
 
  $(".topic_hover").each () ->
    topic_hovercards $(this)

  $(document).on "mouseenter", ".topic_hover", ->
    $(".topic_hover").each () ->
      topic_hovercards $(this)
