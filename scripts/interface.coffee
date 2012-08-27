adjustUI = (numBots) ->
  if numBots == 1
    $('#botsh').hide()
    $('#bots').hide()
    datatable.fnSetColumnVis(5,false);
    openBotInfo packlistArr[0]
  else
    $('#info').hide()
  datatable.fnSettings().aoDrawCallback.push {
    'fn': () ->
      $('#lodan').fadeOut 600
    'sName': 'user'
  }
  bottable.fnDraw()
  datatable.fnDraw()
  datatable.fnAdjustColumnSizing()
  datatable.fnSettings().aoDrawCallback = []

openBotInfo = (id) ->
  infotable.fnClearTable()
  for cat,i in infoHash[id][0]
    infotable.fnAddData [cat, infoHash[id][1][i]]
  $('#infoh').addClass 'toggleable'
  $('#info').slideDown 80, () ->
    reOff()

closeBotInfo = () ->
  $('#infoh').removeClass 'toggleable'
  $('#info').slideUp 80, () ->
    reOff()

onSuccess = (num) ->
  $('#success').text num

onFailure = (num) ->
  $('#fail').text num

bof = 0
reOff = () ->
  bof = $('#bots').offset()
  console.log bof
  $('#bots').css 'height', window.innerHeight-bof.top

$(document).ready () ->  
  $('#searchbox').focus()

  $('#searchbox').keyup () ->
    datatable.fnFilter this.value, 2, true, true
    datatable.fnAdjustColumnSizing()

  bof = $('#bots').offset()
  console.log bof
  $('#bots').css 'height', window.innerHeight-bof.top+16
  $('#packlist').css('height',window.innerHeight)
  $(window).resize () ->
    $('#packlist').css('height',window.innerHeight)
    $('#bots').css 'height', window.innerHeight-bof.top

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
    $('.selected').removeClass 'selected'
    $(event.target.parentNode).addClass 'selected'
    datatable.fnFilter nick, 5
    datatable.fnAdjustColumnSizing()
    openBotInfo revhash[nick]

  $('#allbots').click (event) ->
    datatable.fnFilter '', 5
    $('.selected').removeClass 'selected'
    closeBotInfo()
    return false

  $('body').on 'click', 'h3.toggleable', () ->
    $(this).next().slideToggle 50, () ->
      reOff()
    return false

  # $('body').keydown(function(key)
  #   if (key.keyCode >= 45)
  #     $('#searchbox').focus()
  #   else if (( key.keyCode < 8 || key.keyCode >18 ) && key.keyCode != 32)
  #     $('#searchbox').blur()
