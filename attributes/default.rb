require 'date'

default.github_keys.create_key = true

default.github_keys.remote.user = "github-user"
default.github_keys.remote.password = "SECRET"
default.github_keys.remote.key.name = "github_key installer @#{node.hostname} *** #{DateTime.now.to_s}"

default.github_keys.local.user = "ubuntu"
default.github_keys.local.identity = "github_key_installer"
