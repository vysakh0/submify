$("#topic-nav li a").on "click", ->
  $(this).parent().parent().find(".active").removeClass "active"
  $(this).parent().addClass("active").css "font-weight", "bold"

