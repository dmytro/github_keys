Description
===========

Chef cookbook to generate and deploy SSH keys to user Github account.

Cookbook uses Github API to generate and upload SSH key to user github account. This key can be used later for application deployment from Github. Cookbook uses user name and password to access github API. Name and password are stored as Chef attributes in JSON config file or in Chef data-bag. Data-bags can be optionally encrypted, but encryption is not implemented yet.

SSH keys are generated if key with required filename does not exist.

Upon successful upload of keys to github acount, flag file will be created so that key is uploaded only once and recipe can be run multiple times. Flag file contains timestamp nad name of the key uploaded. Flag file is created in the .ssh directory on the target server.

Example flag file

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$ cat ~/.ssh/id_dsa.uploaded 
title: github_key installer @ubuntu *** 2013-05-19T11:04:54+09:00
user:  dmytro
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Version
===========

See `metadata.rb` file.

Requirements
============


* [Chef-solo-search](https://github.com/edelight/chef-solo-search/) is required when used with chef-solo, since recipe in this cookbook relies on search.

* Tested only on Ubuntu 12.04 and CentOS 6.x with chef-solo. Testing with Chef server required.

* http://tickets.opscode.com/browse/CHEF-3944 Data bag search functionality is not working with Chef 11 at this time. 
  - To use with Chef 11.x version of chef-solo-search containing https://github.com/edelight/chef-solo-search/pull/18/ pull request apparently implements Chef 11 compatibility, however at the time of writing (May, 2013) it didn't work for me. (TODO)

* Version 0.0.2 tested with Ruby 2.0.0-p0 and Chef 11.4.4. Previous version etsted with Ruby 1.9.3 and Chef 10.

Attributes
==========


* `default.github_keys.create_key` = true - set to false if you want to disable this recipe run
* `default.github_keys.upload_key` = true - set to false if you want to disable this recipe run
* `default.github_keys.remote.user` = "github-user" - login name of the github user
* `default.github_keys.remote.password` = "SECRET" - plain text password of Github user. Do not set it in attributes file if you want to upload file to Git.
* `default.github_keys.remote.key` = "github_key installer @#{node.hostname} *** #{DateTime.now.to_s}" - title of the key given in Github's key section. Can be left as specified in default.
* `default.github_keys.local.user` = "ubuntu"  - UNIX login name of the user on local host. Key will be created in user's .ssh directory with the name specified by `identity` attribute (below).
* `default.github_keys.local.identity` = "github_key_installer" - file name for the SSH key.


JSON configurarion
------------------

Add to `deploy.json` file section that overwrites defaults:

````json

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
        
````

Data bags
---------

Remote user name and password attibutes can also be overriden by data bag. 

Data bag name must be `github_keys` and have an id `remote`.

This cookbook can be used with chef-solo. In this case data bags must be provided as files, and please make sure to include "chef-solo-search":https://github.com/edelight/chef-solo-search.git cookbook in your library.

### Example databag

````
{ 
  "id" : "remote",
    "user" : "github-user",
    "password" : "SECRET"
}
````


Changes
===========

* v0.0.2 - added support for Chef 11. 
  * Attribute changes to match Chef 11 
    `default.github_keys.remote.key.name` -> `default.github_keys.remote.key`
  * Remove data bag search, it does not work with Chef11 and chef-solo-search. Reports missing client.pem file. (TODO)
  

License
=======

Apache-2

Author
======

Dmytro Kovalov

dmytro.kovalov@gmail.com

http://dmytro.github.com

Sept, 06, 2012
