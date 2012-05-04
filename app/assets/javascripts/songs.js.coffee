pad = (str, max) ->
  if str.toString().length < max then pad("0" + str, max) else str

jQuery ($) ->
  $('.search-query').on 'keyup', ->
    $.ajax '/?query='+encodeURI(this.value), {dataType: 'script'}

  setInterval ->
    elapsed += 1;
    percent = elapsed / song_length * 100;

    $('.bar').css('width', percent + '%')

    minutes = Math.floor elapsed / 60
    seconds = elapsed % 60
    current = pad(minutes,2)+':'+pad(seconds,2)

    minutes = Math.floor song_length / 60
    seconds = song_length % 60
    total = pad(minutes,2)+':'+pad(seconds,2)

    $('#current_progress').html current + ' / ' + total

    if percent >= 100
      location.reload true
  , 1000
