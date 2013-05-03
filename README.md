Weathervision
=============

Author: Bas Brugman
Company: [visionnaire](http://www.visionnaire.nl)

Weathervision is a weather forecast Ruby Gem for the light-weight system monitor [Conky](http://conky.sourceforge.net).
I've tested it with Conky version 1.8.1 on a Ubuntu 12.04 machine, as well as Conky version 1.9 on Arch Linux.
It should basically work with any modern Linux distro which has Ruby 1.9.3+ installed. 

Weathervision is a commandline tool that spits out some Conky compatible configuration text containing weather information.

There are 2 output modes available:

1. image: renders the weathervision_image.erb template (using .png images located in assets/ to display conditions and wind directions)
2. text: renders the weathervision_text.erb template (using 2 .otf fonts located in fonts/ to display conditions and wind directions)

TODO: install those fonts???

The weather data is extracted from [wunderground](http://www.wunderground.com/)'s JSON API. It's free for personal/developer usage.

Installation
------------

1. Sign up for a free developer account at [wunderground](http://www.wunderground.com/) in order to get your API Key. You need this key
   so weathervision can periodically poll for JSON weather data. The API key is an 8-byte hexadecimal string which needs to be embedded in
   the JSON URL.

   Run weathervision help parse for options... radar_location= empty laten!!

2. 

There are 4 display modes:
  image_v
  image_h
  text_v
  text_h

If you don't like the default look, feel free to hack away in those ERB templates.

sudo apt-get install gifsicle
gem install bundler
bundle
rake build (gem build)
rake install (gem local install)

fonts... templates... execpi...




fonts... templates... execpi...

TODO........
text_buffer_size conky.......... 4096 make sure
rdoc

generate a wrapper script - namely, you need to set it up so that there is an alternative executable
that loads the correct gemset.


gif tool...

rvm wrapper 1.9.3@weathervision bootup weathervision
${execpi 900 /home/stamina/bin/bootup_weathervision parse}

API Key:   033a9fdb3ff2b22f



Note that I'm using English as the weather conditions texts (lang:EN in the JSON urls). If you really want to use a different language
you have to change the key strings in the compare hashes in forecast_parser.rb. These key strings are mapping wind directions to the correct images, e.g. North-North-East NNE.
