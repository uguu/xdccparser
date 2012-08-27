// Generated by CoffeeScript 1.3.3
var adjustUI, bof, closeBotInfo, onFailure, onSuccess, openBotInfo, reOff;

adjustUI = function(numBots) {
  if (numBots === 1) {
    $('#botsh').hide();
    $('#bots').hide();
    datatable.fnSetColumnVis(5, false);
    openBotInfo(packlistArr[0]);
  } else {
    $('#info').hide();
  }
  datatable.fnSettings().aoDrawCallback.push({
    'fn': function() {
      return $('#lodan').fadeOut(600);
    },
    'sName': 'user'
  });
  bottable.fnDraw();
  datatable.fnDraw();
  datatable.fnAdjustColumnSizing();
  return datatable.fnSettings().aoDrawCallback = [];
};

openBotInfo = function(id) {
  var cat, i, _i, _len, _ref;
  infotable.fnClearTable();
  _ref = infoHash[id][0];
  for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
    cat = _ref[i];
    infotable.fnAddData([cat, infoHash[id][1][i]]);
  }
  $('#infoh').addClass('toggleable');
  return $('#info').slideDown(80, function() {
    return reOff();
  });
};

closeBotInfo = function() {
  $('#infoh').removeClass('toggleable');
  return $('#info').slideUp(80, function() {
    return reOff();
  });
};

onSuccess = function(num) {
  return $('#success').text(num);
};

onFailure = function(num) {
  return $('#fail').text(num);
};

bof = 0;

reOff = function() {
  bof = $('#bots').offset();
  console.log(bof);
  return $('#bots').css('height', window.innerHeight - bof.top);
};

$(document).ready(function() {
  $('#searchbox').focus();
  $('#searchbox').keyup(function() {
    datatable.fnFilter(this.value, 2, true, true);
    return datatable.fnAdjustColumnSizing();
  });
  bof = $('#bots').offset();
  console.log(bof);
  $('#bots').css('height', window.innerHeight - bof.top + 16);
  $('#packlist').css('height', window.innerHeight);
  $(window).resize(function() {
    $('#packlist').css('height', window.innerHeight);
    return $('#bots').css('height', window.innerHeight - bof.top);
  });
  $('#packlisttable tbody').click(function(event) {
    var botnick, num, str;
    if (event.target.parentNode.childNodes[5] === void 0) {
      botnick = Object.keys(revhash)[0];
      console.log(botnick);
    } else {
      botnick = event.target.parentNode.childNodes[5].childNodes[0].nodeValue;
    }
    num = event.target.parentNode.childNodes[0].childNodes[0].nodeValue;
    str = '/msg ' + botnick + ' xdcc send ' + num;
    return window.prompt('Copy and paste this into your IRC client', str);
  });
  $('#bottable tbody').click(function(event) {
    var nick;
    nick = event.target.parentNode.childNodes[0].childNodes[0].nodeValue;
    $('.selected').removeClass('selected');
    $(event.target.parentNode).addClass('selected');
    datatable.fnFilter(nick, 5);
    datatable.fnAdjustColumnSizing();
    return openBotInfo(revhash[nick]);
  });
  $('#allbots').click(function(event) {
    datatable.fnFilter('', 5);
    $('.selected').removeClass('selected');
    closeBotInfo();
    return false;
  });
  return $('body').on('click', 'h3.toggleable', function() {
    $(this).next().slideToggle(50, function() {
      return reOff();
    });
    return false;
  });
});
