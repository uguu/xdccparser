adjustUI = (numBots) ->
  if numBots == 1
    $('#botsh').hide()
    $('#bots').hide()
    datatable.fnSetColumnVis(5,false);
  else
    $('#info').hide()

$(document).ready () ->  
  $('#searchbox').focus()

  $('#searchbox').keyup () ->
    datatable.fnFilter this.value, 2, true, true
    datatable.fnAdjustColumnSizing()

  $('#packlist').css('height',window.innerHeight)
  $(window).resize () ->
    $('#packlist').css('height',window.innerHeight)

  $('#packlisttable tbody').click (event) ->
    console.log event
    num = event.target.parentNode.childNodes[0].childNodes[0].nodeValue
    botnick = event.target.parentNode.childNodes[5].childNodes[0].nodeValue
    str = '/msg ' + botnick + ' xdcc send ' + num
    window.prompt 'Copy and paste this into your IRC client', str

  # $('#lists').maccordion()
  $('#lists .head').click () ->
      $(this).next().slideToggle(50)
      return false

  # $('body').keydown(function(key)
  #   if (key.keyCode >= 45)
  #     $('#searchbox').focus()
  #   else if (( key.keyCode < 8 || key.keyCode >18 ) && key.keyCode != 32)
  #     $('#searchbox').blur()
