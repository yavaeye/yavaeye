#= require jquery-1.6.4.js
#= require jquery-ujs.js
#= require jquery-cookies-2.2.0.js
#= require yava.coffee

$ ->
  # aside height
  unless /^\/admin\//.test window.location.pathname
    Yava.layout()
    $(window).resize Yava.layout

  # hide notice
  Yava.setNotice $('.notice').html()

  # tooltip
  $('[data-title]').live('mouseover', Yava.showTip).live 'mouseleave', Yava.hideTip