$(document).ready( function () {
  var datatable = $('#packlisttable').dataTable( {
    'bFilter' : true,
    'sDom': 'lrt',
    'bPaginate': false,
    'oSearch' : { 'bRegex': true },
  });
  
  var infotable = $('#infotable').dataTable( {
    'bFilter' : false,
    'sDom': 'lrt',
    'bPaginate': false,
    'bSort': false,
  });

  $("#searchbox").keyup(function () {
    datatable.fnFilter(this.value, 2, true, true);
   });
  
  $("#body").keydown(function(key) {
    if ( key.keyCode >= 45 ) {
      document.getElementById('searchbox').focus();
    } else if ( ( key.keyCode < 8 || key.keyCode >18 ) && key.keyCode != 32 ) {
      document.getElementById('searchbox').blur();
    }
  });

  $('#packlisttable tbody').click(function(event) {
    var tr = event.target.parentNode;
    
    var str = '/msg ' + botnick + ' XDCC SEND ' + tr.childNodes[0].childNodes[0].nodeValue;

    window.prompt('Copy and paste this into your IRC client', str);
  });
  var botnick; //scope etc
  var parseIrofferXML = function(xml) {
    botnick = xml.getElementsByTagName('currentnick')[0].childNodes[0].nodeValue;
    var packs = xml.getElementsByTagName('pack');
  
    for (i=0; i<packs.length; i++) {
      var pack = packs[i];
      var packnr = pack.getElementsByTagName('packnr')[0].childNodes[0].nodeValue;
      var packgets = pack.getElementsByTagName('packgets')[0].childNodes[0].nodeValue;
      var packname = pack.getElementsByTagName('packname')[0].childNodes[0].nodeValue;
      var packbytes = pack.getElementsByTagName('packbytes')[0].childNodes[0].nodeValue;
      var groupname = pack.getElementsByTagName('groupname')[0].childNodes[0].nodeValue;
      //var packmd5 = pack.getElementsByTagName('md5sum')[0].childNodes[0].nodeValue;

      datatable.fnAddData( [packnr, packgets, packname, packbytes, groupname] );
    }
  };

  var parseInfoXML = function(xml) {
    var data = new Array(0);
    var name = new Array(0);
    data.push(xml.getElementsByTagName('transferedtotal')[0].childNodes[0].nodeValue);
    data.push(xml.getElementsByTagName('slotsfree')[0].childNodes[0].nodeValue + '/' + xml.getElementsByTagName('slotsmax')[0].childNodes[0].nodeValue);
    data.push(xml.getElementsByTagName('queueuse')[0].childNodes[0].nodeValue + '/' + xml.getElementsByTagName('queuemax')[0].childNodes[0].nodeValue);
    data.push(xml.getElementsByTagName('queueuse')[1].childNodes[0].nodeValue + '/' + xml.getElementsByTagName('queuemax')[1].childNodes[0].nodeValue);
    data.push(xml.getElementsByTagName('banduse')[0].childNodes[0].nodeValue);
    data.push(botnick);
    data.push(xml.getElementsByTagName('uptime')[0].childNodes[0].nodeValue);
    name.push('Transferred');
    name.push('Free Slots');
    name.push('Queue');
    name.push('Idlequeue');
    name.push('Curr. Bandwidth');
    name.push('Nick');
    name.push('Uptime');
    for (i=0; i<data.length; i++) {
      infotable.fnAddData( [name[i], data[i]] );
    }
  }

  $.get('drawn-reality.packlist.xml', function(xml) {
    parseIrofferXML(xml);
    parseInfoXML(xml);
    datatable.fnAdjustColumnSizing();
    infotable.fnAdjustColumnSizing();
  });
});