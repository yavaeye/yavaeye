#require jquery-1.6.4.js, jquery-ujs.js, jquery-cookies-2.2.0.js

$ ->
  if $('#posts').height()
    $('aside').height($('#posts').height())