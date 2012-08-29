# expose functions and variables to interface.js
packlistArr = []
packHash = {}; infoHash = {}
revhash = {};
# dohoho bad coding standards
datatable = 0; infotable = 0; bottable = 0;

parsePacklist = () ->
  total = packlistArr.length
  success = 0; fail = 0; grabbed = 0
  $('#total').text total
  $('#msg').text 'Collecting Packlists.'
  fin = () ->
    if(total == grabbed)
      adjustUI total

  parse = (bot, url) ->
    packHash[url] = []
    infoHash[url] = []
    revhash[bot.nick] = url
    for pack,i in bot.packs
      packinfo = [i+1, pack.gets, pack.name, pack.size, pack.group, bot.nick]
      datatable.fnAddData packinfo, false
      packHash[url].push packinfo
    infoHash[url].push ['Transferred','Open Slots','Queue','Idlequeue','Curr. Bandwidth','Uptime','Nick']
    infoHash[url].push [
      bot.transfer.total,
      (bot.slots.max-bot.slots.use)+'/'+bot.slots.max,
      bot.mainqueue.use+'/'+bot.mainqueue.max,
      bot.idlequeue.use+'/'+bot.idlequeue.max,
      bot.bandwidth.use,
      bot.uptime.current,
      bot.nick
    ]
    bottable.fnAddData [bot.nick, bot.packsum], false

  fetch = (url, cb) ->
    $.getJSON(url)
    .done (json) ->
      onSuccess ++success
      cb json, url if packHash[url] == undefined
    .fail () ->
      onFailure ++fail
    .always () ->
      grabbed++
      $('#processed').text i #no loop scope in JS
      fin()

  for bot,i in packlistArr
    fetch bot, parse


parseBotlist = (botlistArr) ->
  grabbed = 0; success = 0; fail = 0
  tograb = botlistArr.length; derp = {}
  $('#total').text tograb
  fin = () ->
    if(tograb == grabbed)
      parsePacklist()
      #call the packlist parsing function

  parse = (json) ->
    newgrab = 0
    for item in json
      switch item.type
        when "packlist"
          packlistArr.push item.loc
        when "botlist"
          botlistArr.push item.loc
          tograb++
          newgrab++
    for i in [0...newgrab]
      fetch botlistArr[grabbed+i], parse

  fetch = (url, cb) ->
    $.getJSON(url)
    .always () ->
      grabbed++
    .done (json) ->
      onSuccess ++success
      cb json if derp[url] != true
    .fail () ->
      onFailure ++fail
    .always () ->
      $('#processed').text grabbed
      $('#total').text tograb
      derp[url] = true
      fin()

  for i in [0...tograb]
    fetch botlistArr[i], parse

$(document).ready () ->
  datatable = $('#packlisttable').dataTable {
    'bFilter'   : true,
    'sDom'      : 'lrt',
    'bPaginate' : false,
    'oSearch'   : { 'bRegex' : true },
    'aaSorting' : [[5,'asc'], [0,'asc']]
  }

  new FixedHeader datatable

  infotable = $('#infotable').dataTable {
    'bFilter'   : false,
    'sDom'      : 'lrt',
    'bPaginate' : false,
    'bSort'     : false
  }

  bottable = $('#bottable').dataTable {
    'bFilter'   : false,
    'sDom'      : 'lrt',
    'bPaginate' : false,
    'aaSorting' : [[0,'asc']]
  }

  parseBotlist ['botlist.json']
  datatable.fnAdjustColumnSizing()
