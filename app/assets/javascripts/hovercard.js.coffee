jQuery ->
  profile_hovercards = (object) ->
    id = "profile_hovercard_#{$(object).attr("data-hovercard")}"
    if not $("#"+id).length
      $("body").append("<div id='#{id}' class='profile_hovercard'></div>")
    $(object).tooltip
      tipClass: 'profile_hovercard'
      effect: 'slide'
      position: 'bottom center'
      delay: 500
      tip: $("#"+id)
      predelay: 500
      onBeforeShow: () =>
        if not $("#"+id).hasClass("loaded")
          $.ajax
            url: "/users/#{$(object).attr("data-hovercard")}/hovercard"
            type: 'GET'
            dataType: 'html'
            success: (data) ->
              $("#"+id).addClass("loaded").html(data)
 
  $(".profile_hover").each () ->
    profile_hovercards $(this)


  $(document).on "mouseenter", ".profile_hover", ->
    $(".profile_hover").each () ->
      profile_hovercards $(this)
	
