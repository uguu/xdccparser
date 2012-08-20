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
    datatable.fnAdjustColumnSizing()
  
  # $('body').keydown(function(key)
  #   if (key.keyCode >= 45)
  #     $('#searchbox').focus()
  #   else if (( key.keyCode < 8 || key.keyCode >18 ) && key.keyCode != 32)
  #     $('#searchbox').blur()

  $('#packlisttable tbody').click (event) ->
    console.log event
    num = event.target.parentNode.childNodes[0].childNodes[0].nodeValue
    botnick = event.target.parentNode.childNodes[5].childNodes[0].nodeValue
    str = '/msg ' + botnick + ' XDCC SEND ' + num
    window.prompt 'Copy and paste this into your IRC client', str

  packlistArr = []
  packHash = {}; infoHash = {}
  revhash = {}

  parsePacklist = () ->
    total = packlistArr.length
    success = 0; fail = 0; grabbed = 0
    parseinfo = (json) ->
      infotable.fnAddData()

    parse = (bot, url) ->
      packHash[url] = []
      infoHash[url] = []
      revhash[bot.nick] = url
      for pack,i in bot.packs
        packinfo = [i+1, pack.gets, pack.name, pack.size, pack.group, bot.nick]
        datatable.fnAddData packinfo
        packHash[url].push packinfo
      infoHash[url].push ['Transferred','Slots','Queue','Idlequeue','Curr. Bandwidth','Uptime']
      infoHash[url].push [
        bot.transfer.total,
        bot.slots.min+'/'+bot.slots.max,
        bot.mainqueue.min+'/'+bot.mainqueue.max,
        bot.idlequeue.min+'/'+bot.idlequeue.max,
        bot.bandwidth.use,
        bot.uptime.current
      ]

    fetch = (url, cb) ->
      $.getJSON(url)
      .always () ->
        grabbed++
        $('#processed').text i #no loop scope in JS
      .done (json) ->
        success++
        $('#success').text success
        cb json, url
      .fail () ->
        fail++
        $('#fail').text fail

    for bot,i in packlistArr
      fetch bot, parse


  parseBotlist = (botlistArr) ->
    grabbed = 0; success = 0; fail = 0
    tograb = botlistArr.length
    fin = () ->
      if(tograb == grabbed)
        parsePacklist()
        #call the packlist parsing function

    parse = (json) ->
      console.log json
      newgrab = 0
      for item in json
        console.log item.type+':'+item.loc
        switch item.type
          when "packlist"
            packlistArr.push item.loc
          when "botlist"
            botlistArr.push item
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
  datatable.fnAdjustColumnSizing()
