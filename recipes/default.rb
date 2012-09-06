#
# Cookbook Name:: github_keys
# Recipe:: default
#
# Copyright 2012, Dmytro Kovalov
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

config = node[:github_keys]
api    = 'https://api.github.com/user/keys'

if config[:create_key]
  
  user = config[:local][:user]
  home = File.expand_path("~#{config[:local][:user]}") 
  
  # Full UNIX PATH to ssh key file
  identity = File.join( home,".ssh", config[:local][:identity] )
  
  directory  File.expand_path("#{home}/.ssh") do
    owner user
    group user
    mode 0700
    action :create
    recursive true
  end
      
  execute :ssh_keygen do
    remote = config[:remote]
    user  user
    group user
    command <<-EOCMD
             ssh-keygen -f #{identity} -t dsa -N ''
             KEY=$(cat #{identity}.pub)
             curl -X POST -L --user #{remote[:user]}:#{remote[:password]} #{api} --data "{\\"title\\":\\"#{remote[:key][:name]}\\", \\"key\\":\\"$KEY\\"}"
EOCMD
    creates "#{identity}"
    action :run
  end
  
end
