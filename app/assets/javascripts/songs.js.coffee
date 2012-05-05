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

jQuery ($) ->
  $('.search-query').on 'keyup', ->
    $.ajax '/?query='+encodeURI(this.value), {dataType: 'script'}

  setInterval ->
    elapsed += 1;
    percent = elapsed / song_length * 100;

    $('.bar').css('width', percent + '%')

    current = format_time elapsed
    total = format_time song_length

    $('#current_progress').html current + ' / ' + total

    if percent >= 100
      location.reload true
  , 1000
