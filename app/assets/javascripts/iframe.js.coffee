$(document).ready ->
  frames = document.getElementsByTagName("iframe")
  i = 0

  while i < frames.length
    frames[i].src += "?wmode=opaque"
    i++

