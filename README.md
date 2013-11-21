### keylab-shell: ssh access and repository management

#### Code status

* [![CI](http://ci.keylab.org/projects/4/status.png?ref=master)](http://ci.keylab.org/projects/4?ref=master)
* [![Build Status](https://travis-ci.org/keylabhq/keylab-shell.png?branch=master)](https://travis-ci.org/keylabhq/keylab-shell)
* [![Code Climate](https://codeclimate.com/github/keylabhq/keylab-shell.png)](https://codeclimate.com/github/keylabhq/keylab-shell)
* [![Coverage Status](https://coveralls.io/repos/keylabhq/keylab-shell/badge.png?branch=master)](https://coveralls.io/r/keylabhq/keylab-shell)


__Requires ruby 1.9+__


### Setup

    ./bin/install


### Check 

    ./bin/check


### Keys: 


Add key

    ./bin/keylab-keys add-key key-782 "ssh-rsa AAAAx321..."

Remove key

    ./bin/keylab-keys rm-key key-23 "ssh-rsa AAAAx321..."

Remove all keys from authorized_keys file

    ./bin/keylab-keys clear

