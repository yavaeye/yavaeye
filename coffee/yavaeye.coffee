#require jquery-1.6.4.js, jquery-ujs.js, jquery-cookies-2.2.0.js

$ ->
  h1 = $('#posts').height() || 0
  h2 = $(window).height()
  $('aside').height(if h1 > h2 then h1 else h2)
  setTimeout (-> $('body > div.notice').fadeOut()), 3000