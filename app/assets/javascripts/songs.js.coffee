jQuery ($) ->
  $('.search-query').on 'keyup', ->
    $.ajax '/?query='+encodeURI(this.value), {dataType: 'script'}

  setInterval ->
    elapsed += 1;
    percent = elapsed / song_length * 100;
    $('.bar').css('width', percent + '%')
    if percent >= 100
      location.reload true
  , 1000