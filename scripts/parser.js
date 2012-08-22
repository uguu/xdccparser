// Generated by CoffeeScript 1.3.3
var bottable, datatable, infoHash, infotable, packHash, packlistArr, parseBotlist, parsePacklist, revhash;

packlistArr = [];

packHash = {};

infoHash = {};

revhash = {};

datatable = 0;

infotable = 0;

bottable = 0;

parsePacklist = function() {
  var bot, fail, fetch, grabbed, i, parse, parseinfo, success, total, _i, _len, _results;
  total = packlistArr.length;
  adjustUI(total);
  success = 0;
  fail = 0;
  grabbed = 0;
  parseinfo = function(json) {
    return infotable.fnAddData();
  };
  parse = function(bot, url) {
    var i, pack, packinfo, _i, _len, _ref;
    packHash[url] = [];
    infoHash[url] = [];
    revhash[bot.nick] = url;
    _ref = bot.packs;
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      pack = _ref[i];
      packinfo = [i + 1, pack.gets, pack.name, pack.size, pack.group, bot.nick];
      datatable.fnAddData(packinfo);
      packHash[url].push(packinfo);
    }
    infoHash[url].push(['Transferred', 'Slots', 'Queue', 'Idlequeue', 'Curr. Bandwidth', 'Uptime']);
    infoHash[url].push([bot.transfer.total, bot.slots.min + '/' + bot.slots.max, bot.mainqueue.min + '/' + bot.mainqueue.max, bot.idlequeue.min + '/' + bot.idlequeue.max, bot.bandwidth.use, bot.uptime.current]);
    return bottable.fnAddData([bot.nick]);
  };
  fetch = function(url, cb) {
    return $.getJSON(url).always(function() {
      grabbed++;
      return $('#processed').text(i);
    }).done(function(json) {
      success++;
      $('#success').text(success);
      return cb(json, url);
    }).fail(function() {
      fail++;
      return $('#fail').text(fail);
    });
  };
  _results = [];
  for (i = _i = 0, _len = packlistArr.length; _i < _len; i = ++_i) {
    bot = packlistArr[i];
    _results.push(fetch(bot, parse));
  }
  return _results;
};

parseBotlist = function(botlistArr) {
  var fail, fetch, fin, grabbed, i, parse, success, tograb, _i, _results;
  grabbed = 0;
  success = 0;
  fail = 0;
  tograb = botlistArr.length;
  fin = function() {
    if (tograb === grabbed) {
      return parsePacklist();
    }
  };
  parse = function(json) {
    var i, item, newgrab, _i, _j, _len;
    console.log(json);
    newgrab = 0;
    for (_i = 0, _len = json.length; _i < _len; _i++) {
      item = json[_i];
      console.log(item.type + ':' + item.loc);
      switch (item.type) {
        case "packlist":
          packlistArr.push(item.loc);
          break;
        case "botlist":
          botlistArr.push(item);
          tograb++;
          newgrab++;
      }
    }
    for (i = _j = 0; 0 <= newgrab ? _j < newgrab : _j > newgrab; i = 0 <= newgrab ? ++_j : --_j) {
      fetch(botlistArr[grabbed + i].loc, parse);
    }
    return fin();
  };
  fetch = function(url, cb) {
    return $.getJSON(url).always(function(json) {
      grabbed++;
      $('#processed').text(grabbed);
      return $('#total').text(tograb);
    }).done(function(json) {
      success++;
      $('#success').text(success);
      return cb(json);
    }).fail(function() {
      fail++;
      return $('#fail').text(fail);
    });
  };
  _results = [];
  for (i = _i = 0; 0 <= tograb ? _i < tograb : _i > tograb; i = 0 <= tograb ? ++_i : --_i) {
    _results.push(fetch(botlistArr[i].loc, parse));
  }
  return _results;
};

$(document).ready(function() {
  datatable = $('#packlisttable').dataTable({
    'bFilter': true,
    'sDom': 'lrt',
    'bPaginate': false,
    'oSearch': {
      'bRegex': true
    },
    'aaSorting': [[5, 'asc'], [0, 'asc']]
  });
  new FixedHeader(datatable);
  infotable = $('#infotable').dataTable({
    'bFilter': false,
    'sDom': 'lrt',
    'bPaginate': false,
    'bSort': false
  });
  bottable = $('#bottable').dataTable({
    'bFilter': false,
    'sDom': 'lrt',
    'bPaginate': false,
    'bSort': false
  });
  parseBotlist([
    {
      loc: 'botlist.json',
      type: 'botlist'
    }
  ]);
  return datatable.fnAdjustColumnSizing();
});
