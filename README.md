# buildboard

buildboard is an [Integrity][1] style dashboard meant to be used in
combination with [CI Joe][2]. It does not provide any build features only
aggregation of the output from a continuous integration system like CI Joe.

[1]: http://www.integrityapp.com
[2]: http://github.com/defunkt/cijoe

## Screenshots:

The project details page:

![Details](http://img.skitch.com/20100701-frm785bnmwtssiqg336mcbcmc9.png)


## Getting started

To get started run:

    gem install buildboard
    buildboard

This will provide you with a running buildboard instance on port 5678 if
nothing else is already running on that port.

## Setting up CI Joe

To start collecting data from CI Joe setup a `build-failed` and a
`build-worked` hook with the following content:

    #!/bin/sh
    update-buildboard --directory [path to your CI Joe working repository]

See the CI Joe documentation if you're in doubt about this.

The options for update-buildboard are:

    Usage: update-buildboard [-hpd]

    Specific options:
        -h, --host=HOST                  The hostname or ip of the host running buildboard (default 127.0.0.1)
        -p, --port=PORT                  The port buildboard is running on (default 5678)
        -d, --directory=DIRECTORY        The directory containing the CI Joe repository

## Inner workings

You don't need to know this if you don't care.

All build information are stored in files in $HOME/.buildboard, they're just
YAML files, go peek if you want.

The protocol for integrating with buildboard can be derived from Build#load\_file.

## Acknowledgements

buildboard is based on and/or stole from, and would like to thank:

* [Integrity][1] provided a nice design to steal
* [CI Joe][2] is the reason buildboard was made
* [Sinatra][3] is the muse that underlies it all
* [Vegas][4] for making it crazy easy to provide a stage for Sinatra

[3]: http://www.sinatrarb.com/
[4]: http://code.quirkey.com/vegas/

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Jacob Atzen. See LICENSE for details.
