Description
===========

Simple Chef cookbook to generate and deploy keys to user's Github account.

Requirements
============

Tested only on Ubuntu 12.04 with chef-solo. Further testing required.

Attributes
==========


* default.github_keys.create_key = true - set to false if you want to disable this recipe run

* default.github_keys.remote.user = "github-user" - login name of the github user

* default.github_keys.remote.password = "SECRET" - plain text password of Github user. Do not set it in attributes file if you want to upload file to Git.

* default.github_keys.remote.key.name = "github_key installer @#{node.hostname} *** #{DateTime.now.to_s}" - title of the key given in Github's key section. Can be left as specified in default.

* default.github_keys.local.user = "ubuntu"  - UNIX login name of the user on local host. Key will be created in user's .ssh directory with the name specified by `identity` attribute (below).

* default.github_keys.local.identity = "github_key_installer" - file name for the SSH key.


Usage
=====


Add to `deploy.json` file section that overwrites defaults:

    "github_keys" : {
        "local" : {
            "user" : "ubuntu"
        },
        "remote" : {
            "user" : "dmytro",
            "password": "SECRET_PASSWORD"
        }
    },                 

    "run_list": [
    ...
        "recipe[github_keys]",
        ]

License
=======

Apache-2

Author
======

Dmytro Kovalov

dmytro.kovalov@gmail.com

http://dmytro.github.com

Sept, 06, 2012

