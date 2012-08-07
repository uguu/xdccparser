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
  
  // $("#body").keydown(function(key) {
  //   if ( key.keyCode >= 45 ) {
  //     $("#searchbox").focus();
  //   } else if ( ( key.keyCode < 8 || key.keyCode >18 ) && key.keyCode != 32 ) {
  //     $("#searchbox").blur();
  //   }
  // });

  var botnick;
  $('#packlisttable tbody').click(function(event) {
    var num = event.target.parentNode.childNodes[0].childNodes[0].nodeValue;
    var str = '/msg ' + botnick + ' XDCC SEND ' + num
    window.prompt('Copy and paste this into your IRC client',str);
  });

  var handlePacks = function(packs) {
    for (i=0; i<packs.length; i++) {
      var pack = packs[i];
      datatable.fnAddData( [i+1, pack.gets, pack.name, pack.size, pack.group] );
    }
  }

  $.getJSON('d-r.packlist.json', function(botlist) {
    handlePacks(botlist.packs);
    botnick = botlist.nick;
    datatable.fnAdjustColumnSizing();
    infotable.fnAdjustColumnSizing();
  });
});