#= require js/jquery-1.7.2
#= require js/jquery-ujs
#= require js/jquery-cookie
#= require js/yava
#= require js/profile

$ ->
  # hide notice
  Yava.setNotice $('.notice').html()

  # tooltip
  $('[data-title]').live('mouseover', Yava.showTip).live 'mouseleave', Yava.hideTip

  # profile
  Profile.ready ->
    tags = $ '#tags'
    for tag in Profile.data['subscribed_tags']
      elem =
        if "/tag/#{tag}" == window.location.path
          $('<span/>')
        else
          $("<a href='/tag/#{encodeURIComponent tag}'/>")
      elem.addClass('tag-card').text(tag)
      tags.append elem

$('form').live 'ajax:success', (e, data)->
  elem = $ @
  data = $.parseJSON data
  if data.error
    for prefix, error of data.error
      Yava.tagFormError elem, prefix, error
  else if data.redirect # NOTE that 301-303 doesn't work, jquery ajax follows them
    window.location = data.redirect
  else if data.notice
    Yava.setNotice data.notice
  else
    console.log 'unsupported response:'
    console.log data

# $('form').live 'ajax:before', ()-> true|false

$('form').live 'ajax:error', (req)->
  unless notice = req.responseText
    notice = switch req.status
      when 500 then '恭喜你,服务器出错了'
      when 404 then '东西没找到...'
      when 403 then '你无权这么做'
      else '与服务器联系失败'
  Yava.setNotice notice

$('form').live 'ajax:aborted:required', (e, elems)->
  elems.each (elem)->
    Yava.tagFieldError elem, '不能为空'
