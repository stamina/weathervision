Weathervision
=============

Author: Bas Brugman
Company: [visionnaire](http://www.visionnaire.nl)

Weathervision is a weather forecast Ruby Gem for the light-weight system monitor [Conky](http://conky.sourceforge.net).
I've only tested it with conky version 1.8.1 on a Xubuntu 11.10 machine, but it should basically work in any modern environment.

The weather data is extracted from [wunderground](http://www.wunderground.com/). It's free for personal usage. Please read Wunderground's
terms & conditions for commercial usage.

Installation
------------

Error: calc_wind_icon: 182 Nill class [] ........blablaal

fonts... templates... execpi...

images...

        %x(wget #{@params["radar_url"]} -O #{outfile} 2>&1 >/dev/null)
        %x(gifsicle -w --colors=255 #{outfile} > #{RADAR_PATH + '/temp.gif'})
        %x(gifsicle -U #{RADAR_PATH + '/temp.gif'} "#-1" > #{RADAR_PATH + '/radar.gif'})

Customization
-------------


fonts... templates... execpi...

TODO........
text_buffer_size conky.......... 4096 make sure

generate a wrapper script - namely, you need to set it up so that there is an alternative executable that loads the correct gemset.

As an example, if you'd installed god under ruby enterprise edition and in the management gemset (aka. "ree@management"), you'd do the following:

gif tool...

rvm wrapper ree@management bootup god
rvm wrapper 1.9.2@weathervision bootup weathervision
${execpi 900 /home/stamina/bin/bootup_weathervision parse}


