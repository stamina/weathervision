Weathervision
=============

Author: Bas Brugman
Company: [visionnaire](http://www.visionnaire.nl)

Weathervision is a weather forecast Ruby gem for the light-weight system monitor [Conky](http://conky.sourceforge.net).
(Tested with conky version 1.8.1)

The weather data is extracted from [wunderground](http://www.wunderground.com/). Please read Wunderground's
terms & conditions for commercial usage.

Installation
------------

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


