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
$(document).ready ->
  page_tab = $("#page_tab").val()
  $("#cool").val(page_tab)
  if page_tab is "links"
    $(".links_user").addClass "active"
  else if page_tab is "comments"
    $(".comments_user").addClass "active"
  else $(".followers_user").addClass "active"  if page_tab is "followers"
