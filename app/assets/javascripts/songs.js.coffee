pad = (str, max) ->
  if str.toString().length < max then pad("0" + str, max) else str

format_time = (seconds) ->
  hours = parseInt( seconds / 3600 ) % 24;
  minutes = parseInt( seconds / 60 ) % 60;
  seconds = seconds % 60;
  if hours > 0
    current = hours + ':' + pad(minutes,2) + ':' + pad(seconds,2)
  else
    current = minutes + ':' + pad(seconds,2)

window.cancel_search = ->
  key.setScope('all')
  $('.navbar-search input').val('').keyup().blur()
  $('#cancel-search').hide()

window.highlight_selected_song = ->
  $('#song_list tr').removeClass('selected')
  $('#song_list tr:eq('+selected_song+')').addClass('selected')

jQuery ($) ->
  $('.search-query')
  .on 'keyup', (e) ->
    return false if e.keyCode in [37..40]

    $.ajax '/?query='+encodeURI(this.value.replace(/^\s+|\s+$/g,'')), {dataType: 'script'}
    $('#cancel-search').show()
    if this.value == ''
      $('#cancel-search').hide()
  .focus ->
    key.setScope('searching')

  $('#cancel-search').on 'click', ->
    cancel_search()

  $(document).on 'click', '.pagination a', ->
    window.selected_song = null

  setInterval ->
    return if elapsed == null

    elapsed += 1;
    percent = elapsed / song_length * 100;

    $('.bar').css('width', percent + '%')

    current = format_time elapsed
    total = format_time song_length

    $('#current_progress').html current + ' / ' + total

    if percent >= 100
      $('#queue').load '/songs/queue'
  , 1000
