# utils

window.Yava =
  tagFieldError: (elem, errors) ->
    elem.parent().find('.field-error').remove()
    errors = errors.join '. ' if errors.join
    elem.after("<div class='field-error'>#{errors}</div>")

  tagFormError: (elem, prefix, errors) ->
    elem = $ elem
    elem.find('.field-error').remove()
    prefix = "#" + prefix unless /^\#/.test prefix
    prefix = prefix + "_" unless /_$/.test prefix
    if errors.base
      elem.prepend "<div class='field-error'>#{errors.base}</div>"
    for field, info of errors
      info = info.join ". "
      elem.find(prefix + field).after "<div class='field-error'>#{info}</div>"
    elem.find('.submit').removeAttr('disabled')

  setNotice: (text) ->
    $('div.notice').replaceWith("<div class='notice'>" + text + "</div>")
    setTimeout (-> $('.notice').fadeOut 1500), 2500

  layout: ->
    h1 = $('#posts').height() || 0
    h2 = $(window).height()
    $('aside').height(if h1 > h2 then h1 else h2)

  # showTip() and hideTip() are for hover tooltip [title] enchancement
  #   from http://onehackoranother.com/projects/jquery/tipsy/
  # modified for live and simplified

  # function for dom binding
  showTip: ->
    self = $ @
    # we don't use the 'title' attr, use data-title instead
    # because we have to remove title from being shown
    # and then the live mouseleave event will be broken because elem has no [title]
    title = self.data('title')

    # build tip dom
    return unless title
    tip = self.data('active.tipsy')
    unless tip
      tip = $("<div class='tipsy' style='position:absolute;z-index:100000;'><div class='tipsy-inner'></div></div>")
      tip.find('.tipsy-inner').text(title)
      self.data('active.tipsy', tip)
      tip.appendTo(document.body)
    tip.css(top: 0, left: 0)

    # config pos and do auto gravity if data-title-gravity is not set
    pos = $.extend({}, self.offset(), {width: @offsetWidth, height: @offsetHeight})
    actualWidth = tip[0].offsetWidth
    actualHeight = tip[0].offsetHeight
    # NOTE: gravity == north means the earth is on top and the tip is shown on top side
    gravity = self.data('title-gravity')
    unless gravity
      # default: use auto gravity
      gravity =
        if self.offset().top > ($(document).scrollTop() + $(window).height() / 2)
          's'
        else
          'n'
    switch gravity.charAt(0)
      when 'n'
        tip.css(top: pos.top + pos.height, left: pos.left + pos.width / 2 - actualWidth / 2).addClass('tipsy-north')
      when 's'
        tip.css(top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2).addClass('tipsy-south')
      when 'e'
        tip.css(top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth).addClass('tipsy-east')
      when 'w'
        tip.css(top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width).addClass('tipsy-west')
    undefined

  # function for dom binding
  hideTip: ->
    tip = $(@).data('active.tipsy')
    $(@).removeData('active.tipsy')
    tip.remove() if tip
    undefined
