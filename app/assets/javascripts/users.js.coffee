# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  page_tab = $('.page_tab').val()
  if page_tab is "links"
    $(".links_user").addClass "active"
  else if page_tab is "comments"
    $(".comments_user").addClass "active"
  else $(".followers_user").addClass "active"  if page_tab is "followers"
