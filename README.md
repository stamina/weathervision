Weathervision
=============

Author: Bas Brugman
Company: [visionnaire](http://www.visionnaire.nl)

Weathervision is a weather forecast Ruby Gem for the light-weight system monitor [Conky](http://conky.sourceforge.net).
I've only tested it with conky version 1.8.1 on a Ubuntu 12.04 machine, but it should basically work with any modern Linux distro.

The weather data is extracted from [wunderground](http://www.wunderground.com/). It's free for personal usage. Please read Wunderground's
terms & conditions for commercial usage.

Installation
------------

TODO: stupid oude debug eruit, nieuwe debugger gem erin... RSPECS nalopen met rspec 2.9
debugging gem moet ook niet installen in "production" env

The weather icons only look good with a dark background.

sudo apt-get install gifsicle
gem install bundler
bundle
rake build (gem build)
rake install (gem local install)

fonts... templates... execpi...

images...

        %x(wget #{@params["radar_url"]} -O #{outfile} 2>&1 >/dev/null)
        %x(gifsicle -w --colors=255 #{outfile} > #{RADAR_PATH + '/temp.gif'})
        %x(gifsicle -U #{RADAR_PATH + '/temp.gif'} "#-1" > #{RADAR_PATH + '/radar.gif'})

Error:

[ ] Betere afvanging gevulde objecten bij ophalen data!!!!

getaddrinfo: Name or service not known
/home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/gems/weathervision-1.0.0/lib/weathervision/forecast_parser.rb:182:in `calc_wind_icon': undefined method `[]' for nil:NilClass (NoMethodError)
        from /home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/gems/weathervision-1.0.0/lib/weathervision/forecast_parser.rb:123:in `show_image_version'
        from /home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/gems/weathervision-1.0.0/lib/weathervision/forecast_parser.rb:117:in `parse'
        from /home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/gems/weathervision-1.0.0/lib/weathervision/cli.rb:11:in `parse'

/home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/gems/weathervision-1.0.0/lib/weathervision/forecast_parser.rb:246:in `parse_current': undefined method `css' for nil:NilClass (NoMethodError)
        from /home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/gems/weathervision-1.0.0/lib/weathervision/forecast_parser.rb:116:in `parse'
        from /home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/gems/weathervision-1.0.0/lib/weathervision/cli.rb:11:in `parse'
        from /home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/gems/thor-0.14.6/lib/thor/task.rb:22:in `run'
        from /home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/gems/thor-0.14.6/lib/thor/invocation.rb:118:in `invoke_task'
        from /home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/gems/thor-0.14.6/lib/thor.rb:263:in `dispatch'
        from /home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/gems/thor-0.14.6/lib/thor/base.rb:389:in `start'
        from /home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/gems/weathervision-1.0.0/bin/weathervision:4:in `<top (required)>'
        from /home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/bin/weathervision:19:in `load'
        from /home/stamina/.rvm/gems/ruby-1.9.3-p125@weathervision/bin/weathervision:19:in `<main>'

Customization
-------------


fonts... templates... execpi...

TODO........
text_buffer_size conky.......... 4096 make sure

generate a wrapper script - namely, you need to set it up so that there is an alternative executable
that loads the correct gemset.


gif tool...

rvm wrapper 1.9.3@weathervision bootup weathervision
${execpi 900 /home/stamina/bin/bootup_weathervision parse}


