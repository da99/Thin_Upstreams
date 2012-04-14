
Thin\_Upstreams
================

A Ruby gem to generate .conf files with upstreams
to include in your nginx.conf. It uses your Thin
configuration files.

Installation
------------

    gem 'Thin_Upstreams'

Notes
-----
 
File upstreams.conf is created in current working directory.
You can't specify file output name.

Usage: In Ruby
------

Accepts optional file globs:

    require "Thin_Upstreams"
    
    Dir.chdir("/apps") {
      Thin_Upstreams()
      Thin_Upstreams "*/configs/my.thin.yml", "./**/config.yml"
    }
    
File /app/upstreams.conf is created/overwritten. You

Usage: Bash/Shell
------

File glob arguments are optional:

    cd /apps
    Thin_Upstreams
    Thin_Upstreams "*/configs/my.thin.yml", "./**/config.yml"

File /app/upstreams.conf is created/overwritten.

Run Tests
---------

    git clone git@github.com:da99/Thin_Upstreams.git
    cd Thin_Upstreams
    bundle update
    bundle exec bacon spec/main.rb

"I hate writing."
-----------------------------

If you know of existing software that makes the above redundant,
please tell me. The last thing I want to do is maintain code.

