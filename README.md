### keylab-shell: ssh access and repository management

#### Code status

* [![Build Status](https://travis-ci.org/derekstavis/keylab-shell.png?branch=master)](https://travis-ci.org/derekstavis/keylab-shell)
* [![Code Climate](https://codeclimate.com/github/derekstavis/keylab-shell.png)](https://codeclimate.com/github/derekstavis/keylab-shell)
* [![Coverage Status](https://coveralls.io/repos/derekstavis/keylab-shell/badge.png?branch=master)](https://coveralls.io/r/derekstavis/keylab-shell)


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

