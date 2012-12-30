jQuery ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.next_page a').attr('href')

 #this stuff got my ass off!!! railscasts shows it as .pagination .next_page but after some look at the query api and trial error,found it:)

      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
        $('.pagination').text("Loading more...")
        $.getScript(url)
    $(window).scroll()
  $(".profile_hover").each () ->
    profile_hovercards $(this)
