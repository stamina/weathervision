Weathervision
=============

Author: Bas Brugman  
Company: [visionnaire](http://www.visionnaire.nl)

Weathervision is a weather forecast Ruby Gem for the light-weight system monitor [Conky](http://conky.sourceforge.net).
I've tested it with Conky version 1.8.1 on a Ubuntu 12.04 machine, as well as Conky version 1.9 on Arch Linux.
It should basically work with any modern Linux distro which has Ruby 1.9.3+ installed. 

![Vertical Layout](https://github.com/stamina/weathervision/raw/master/assets/screenshots/vertical_layout.png "Vertical Layout")

Weathervision is a commandline tool that spits out some Conky compatible template text containing weather information.

There are 2 output modes available:

1. himage: horizontal template, renders the weathervision_himage.erb template
2. vimage: vertical template, renders the weathervision_vimage.erb template

Both templates contain links to weather-related images in the assets/ directory.

You probably want to tweak these templates to your liking. After all, conky is all about giving your desktop a personal touch.

The weather data is extracted from [wunderground](http://www.wunderground.com/)'s JSON API. It's free for personal/developer usage.

Installation
------------

1. Sign up for a free developer account at [wunderground](http://www.wunderground.com/) in order to get your API Key. You need this key
   so weathervision can periodically poll for JSON weather data. The API key is an 8-byte hexadecimal string which needs to be embedded in
   the JSON URL. Also check the wunderground API docs for your correct location string.


2. Since weathervision is a command-line Ruby script (Thor gem used), it's probably a good idea to make a rvm wrapper script to make it
   system-wide callable from your conky launch command: rvm wrapper 1.9.3@weathervision bootup weathervision

   Again, see the RVM documentation for more detail about wrapper scripts (rvm wrapper ruby@gemset [scope] [binary-name])

3. Execute the weathervision command with specific interval from within your conky configuration file:

   ${execpi 900 /home/user/.rvm/bin/bootup_weathervision parse --apikey=[yourapikey] --mode=himage --current-location=[yourlocation] --forecast-location=[yourlocation]}

   There is also a radar-location option available that shows a little .gif image of your country/area's radar data (rain). You can disable it by adding the following
   EMPTY option: --radar-location=

   If you want to display your own radar image, check the forecast_parser.rb source, since I'm doing some post-processing (resizing, cropping) on the image with ImageMagick's convert tool.


Customization
-------------

Note that I'm using English as the weather conditions texts (lang:EN in the JSON urls in forecast_parser.rb). If you really want to use a different language
you have to change the keys in the compare hashes in forecast_parser.rb. These key strings are mapping wind directions to the correct images, e.g. North-North-East NNE.
