
Thin\_Upstreams
================

A Ruby gem to generate partial .conf files with upstreams
to include in your nginx.conf. It uses your Thin
.yml configuration files.

Assuming you have a directory structure of:

    /cwd (current working directory)
      |-- Hi/config/thin.yml    (port 6010, servers 3)
      |-- Hello/config/thin.yml (port 7000, servers 2)

The file would be generated as `/cwd/upstreams.conf`:
     
    upstream Hi {
      server 127.0.0.1:6010;
      server 127.0.0.1:6011;
      server 127.0.0.1:6012;
    }

    upstream Hello {
      server 127.0.0.1:7000;
      server 127.0.0.1:7001;
    }

Then, in your nginx.conf:

    # ... your other settings
    
    http {
    
       # ... your other settings

       include /cwd/upstreams.conf;

       server {
      
         location / {
           proxy_pass http://Hi;
         }
        
         location /sub {
           proxy_pass http://Hello;
         }
       }
    }


Installation
------------

    gem install Thin_Upstreams

Note: Output File
----

* Output file name: `upstreams.conf`
* You can't specify file output name.
* File is overwritten. No safety checks or warnings.


Usage: In Ruby
------

    require "Thin_Upstreams"
    
    Dir.chdir("/my_apps") {
    
      Thin_Upstreams()
      # or...
      Thin_Upstreams "*/configs/my.thin.yml"
      
      # File /my_apps/upstreams.conf is 
      #   created/overwritten.
    }
    
The file glob follows the same format use by [Dir.glob](http://ruby-doc.org/core-1.9.3/Dir.html#method-c-glob).

**Remember**: Use `Thin_Upstreams()`, not `Thin_Upstreams`, when using no arguments.

Usage: Bash/Shell
------

    cd /my_apps
    Thin_Upstreams
    Thin_Upstreams "*/configs/thin.yml"

**Remember**: Use single quotation marks when using a Ruby-style glob in your shell to 
prevent your shell from expanding the glob:

    Thin_Upstreams '*/{configs,.}/thin.yml'

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

