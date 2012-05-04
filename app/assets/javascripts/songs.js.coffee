jQuery ($) ->
  $('.search-query').on 'keyup', ->

    $.ajax '/?query='+encodeURI(this.value), {dataType: 'script'}
