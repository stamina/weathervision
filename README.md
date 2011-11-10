Weathervision
=============

Author: Bas Brugman
Company: [visionnaire](http://www.visionnaire.nl)

Weathervision is a weather forecast Ruby Gem for the light-weight system monitor [Conky](http://conky.sourceforge.net).
Tested with conky version 1.8.1, running Xubuntu 11.04.

The weather data is extracted from [wunderground](http://www.wunderground.com/). It's free for personal usage. Please read Wunderground's
terms & conditions for commercial usage.

Installation
------------

fonts... templates... execpi...

images...

        %x(wget #{@params["radar_url"]} -O #{outfile} 2>&1 >/dev/null)
        %x(gifsicle -w --colors=255 #{outfile} > #{RADAR_PATH + '/temp.gif'})
        %x(gifsicle -U #{RADAR_PATH + '/temp.gif'} "#-1" > #{RADAR_PATH + '/radar.gif'})

ERROR gevonden................
/home/stamina/.rvm/gems/ruby-1.9.2-p290@weathervision/gems/weathervision-1.0.0/lib/weathervision/forecast_parser.rb:182:in `calc_wind_icon': undefined method `[]' for nil:NilClass (NoMethodError)
        from /home/stamina/.rvm/gems/ruby-1.9.2-p290@weathervision/gems/weathervision-1.0.0/lib/weathervision/forecast_parser.rb:123:in `show_image_version'
        from /home/stamina/.rvm/gems/ruby-1.9.2-p290@weathervision/gems/weathervision-1.0.0/lib/weathervision/forecast_parser.rb:117:in `parse'
        from /home/stamina/.rvm/gems/ruby-1.9.2-p290@weathervision/gems/weathervision-1.0.0/lib/weathervision/cli.rb:11:in `parse'
        from /home/stamina/.rvm/gems/ruby-1.9.2-p290@weathervision/gems/thor-0.14.6/lib/thor/task.rb:22:in `run'
        from /home/stamina/.rvm/gems/ruby-1.9.2-p290@weathervision/gems/thor-0.14.6/lib/thor/invocation.rb:118:in `invoke_task'
        from /home/stamina/.rvm/gems/ruby-1.9.2-p290@weathervision/gems/thor-0.14.6/lib/thor.rb:263:in `dispatch'
        from /home/stamina/.rvm/gems/ruby-1.9.2-p290@weathervision/gems/thor-0.14.6/lib/thor/base.rb:389:in `start'
        from /home/stamina/.rvm/gems/ruby-1.9.2-p290@weathervision/gems/weathervision-1.0.0/bin/weathervision:4:in `<top (required)>'
        from /home/stamina/.rvm/gems/ruby-1.9.2-p290@weathervision/bin/weathervision:19:in `load'
        from /home/stamina/.rvm/gems/ruby-1.9.2-p290@weathervision/bin/weathervision:19:in `<main>'


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


