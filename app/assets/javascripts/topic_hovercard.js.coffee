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
