$(document).ready ->
  page_tab = $("#page_tab").val()
  $("#cool").val(page_tab)
  if page_tab is "links"
    $(".links_user").addClass "active"
  else if page_tab is "comments"
    $(".comments_user").addClass "active"
  else $(".followers_user").addClass "active"  if page_tab is "followers"
