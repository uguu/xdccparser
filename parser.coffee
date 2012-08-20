$(document).ready () ->
  datatable = $('#packlisttable').dataTable {
    'bFilter'   : true,
    'sDom'      : 'lrt',
    'bPaginate' : false,
    'oSearch'   : { 'bRegex' : true }
  }

  infotable = $('#infotable').dataTable {
    'bFilter'   : false,
    'sDom'      : 'lrt',
    'bPaginate' : false,
    'bSort'     : false,
  }

  $('#searchbox').keyup () ->
    datatable.fnFilter this.value, 2, true, true
  
  # $('body').keydown(function(key)
  #   if (key.keyCode >= 45)
  #     $('#searchbox').focus()
  #   else if (( key.keyCode < 8 || key.keyCode >18 ) && key.keyCode != 32)
  #     $('#searchbox').blur()

  $('#packlisttable tbody').click (event) ->
    num = event.target.parentNode.childNodes[0].childNodes[0].nodeValue
    botnick = event.target.parentNode.childNodes[0].childNodes[2].nodeValue
    str = '/msg ' + botnick + ' XDCC SEND ' + num
    window.prompt 'Copy and paste this into your IRC client', str

  packlistArr = []
  parseBotlist = (botlistArr) ->
    grabbed = 0
    tograb = botlistArr.length
    success = 0
    fail = 0
    fin = () ->
      console.log tograb+'vs'+grabbed
      if(tograb == grabbed)
        console.log packlistArr
        console.log botlistArr
        #call the packlist parsing function

    parse = (json) ->
      console.log json
      newgrab = 0
      for i in json
        console.log i.type+':'+i.loc
        switch i.type
          when "packlist"
            packlistArr.push i.loc
          when "botlist"
            botlistArr.push i
            tograb++
            newgrab++
      for i in [0...newgrab]
        fetch botlistArr[grabbed+i].loc, parse
      fin()

    fetch = (url, cb) ->
      $.getJSON(url)
      .always (json) ->
        grabbed++
        $('#processed').text grabbed
        $('#total').text tograb
      .done (json) ->
        success++
        $('#success').text success
        cb json
      .fail () ->
        fail++
        $('#fail').text fail

    for i in [0...tograb]
      fetch botlistArr[i].loc, parse

  parseBotlist [{loc: 'botlist.json', type: 'botlist'}]
