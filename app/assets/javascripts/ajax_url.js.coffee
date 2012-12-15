if history and history.pushState
  $ ->
    $(".breadcrumb a").live "click", (e) ->
      $.getScript @href
      history.pushState null, document.title, @href
      e.preventDefault()

    $(window).bind "popstate", ->
      $.getScript location.href


