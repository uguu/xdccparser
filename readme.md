### JSON XDCCParser ###
#### About ####
This is a packlist indexer for [iroffer-dinoex][irod] irc bots. It provides similar functionality to the more venerable [php xdccparser][xdccp] or Dinoex's own [iroffer-state][irod]: a searchable weblisting of one or more bot's packlists.

#### Requirements ####
 - [Iroffer-Dinoex][irod], built with ruby support and http server.
 - The RubyGem [JSON][rjson].

If your bot is hosted on a separate domain:

 - An http daemon that can handle CORS requests properly (Apache, nginx, and lighttpd will all work with a bit of configuration).

#### [Setup and Installation][wiki] ###

#### Too Much Information ####
Similar to the discontinued [XDCC Parser Single][xdccp] mentioned above, this script fetches the bot's packlist on page load, rather than storing a cached version. However, it has several advantages over that:

 - It doesn't require any server-side scripting whatsoever, only a normal http daemon.
 - The packlisting it fetches is generated on request, meaning it's as up-to-date as possible.
 - It natively supports single- or multi-bot setups, and automatically switches between the two.
 - Distributed botlist files allow independently maintained lists of packlists on a single instance.
 - Supports regular expression searches.
 - Extremely simple configuration.

[xdccp]: http://xdccparser.is-fabulo.us/
[irod]: http://iroffer.dinoex.net/
[rjson]: http://flori.github.com/json/
[wiki]: https://github.com/uguu/xdccparser/wiki