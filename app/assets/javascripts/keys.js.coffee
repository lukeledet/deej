window.selected_song = null

key.filter = (e) -> true

key '/,s', ->
  return if $('.navbar-search input').is(':focus')
  $('.navbar-search input').focus()
  return false

key 'escape', 'searching', ->
  cancel_search()
  return false

key 'down', ->
  $('.navbar-search input').blur()
  window.selected_song = if selected_song != null then selected_song + 1 else 1
  window.selected_song = $('#song_list tr').length - 1 if selected_song >= $('#song_list tr').length

  highlight_selected_song()

  return false

key 'up', ->
  return if $('.navbar-search input').is(':focus')

  $('.navbar-search input').blur()
  window.selected_song = if selected_song != null then selected_song - 1 else 1

  if selected_song < 1
    $('.navbar-search input').focus()
    window.selected_song = null

  highlight_selected_song()

  return false

key 'left', ->
  return if $('.navbar-search input').is(':focus')
  $('.pagination .prev a').click()
  return false

key 'right', ->
  return if $('.navbar-search input').is(':focus')
  $('.pagination .next_page a').click()
  return false

key 'enter', ->
  return if $('.navbar-search input').is(':focus')
  $('#song_list tr:eq('+selected_song+') a.vote').click()
