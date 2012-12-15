$(".del_comment").bind "ajax:success", ->
  $(this).closest("li").fadeOut()
$(".unsubmit").bind "ajax:success", ->
  $(this).closest("li").fadeOut()

