# todo checksum
window.Profile =
  ready: (callback) ->
    profile = window.localStorage.getItem 'yava'
    if profile
      Profile.data = $.parseJSON profile
      callback()
    else
      $.get '/user/profile', (data) ->
        window.localStorage.setItem 'yava', data
        Profile.data = $.parseJSON profile
        callback()
