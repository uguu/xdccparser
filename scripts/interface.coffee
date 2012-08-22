adjustUI = (numBots) ->
  if numBots == 1
    $('#botsh').hide()
    $('#bots').hide()
    datatable.fnSetColumnVis(5,false);
    datatable.fnAdjustColumnSizing()
    openBotInfo packlistArr[0]
  else
    $('#info').hide()

openBotInfo = (id) ->
  infotable.fnClearTable()
  for cat,i in infoHash[id][0]
    infotable.fnAddData [cat, infoHash[id][1][i]]
  $('#infoh').addClass 'toggleable'
  $('#info').slideDown 50

closeBotInfo = () ->
  $('#infoh').removeClass 'toggleable'
  $('#info').slideUp 50

$(document).ready () ->  
  $('#searchbox').focus()

  $('#searchbox').keyup () ->
    datatable.fnFilter this.value, 2, true, true
    datatable.fnAdjustColumnSizing()

  $('#packlist').css('height',window.innerHeight)
  $(window).resize () ->
    $('#packlist').css('height',window.innerHeight)

  $('#packlisttable tbody').click (event) ->
    if event.target.parentNode.childNodes[5] == undefined
      botnick = Object.keys(revhash)[0]
      console.log botnick
    else
      botnick = event.target.parentNode.childNodes[5].childNodes[0].nodeValue
    num = event.target.parentNode.childNodes[0].childNodes[0].nodeValue
    str = '/msg ' + botnick + ' xdcc send ' + num
    window.prompt 'Copy and paste this into your IRC client', str

  $('#bottable tbody').click (event) ->
    nick = event.target.parentNode.childNodes[0].childNodes[0].nodeValue
    datatable.fnFilter nick, 5
    datatable.fnAdjustColumnSizing()
    openBotInfo revhash[nick]

  $('#allbots').click (event) ->
    datatable.fnFilter '',5
    closeBotInfo()
    return false

  $('body').on 'click', 'h3.toggleable', () ->
    $(this).next().slideToggle 50
    return false

  # $('body').keydown(function(key)
  #   if (key.keyCode >= 45)
  #     $('#searchbox').focus()
  #   else if (( key.keyCode < 8 || key.keyCode >18 ) && key.keyCode != 32)
  #     $('#searchbox').blur()
