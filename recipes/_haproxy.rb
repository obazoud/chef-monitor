#
# Cookbook Name:: monitor
# Recipe:: _haproxy
#
# Copyright 2013, Sean Porter Consulting
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

include_recipe 'monitor::default'

# sensu_gem 'haproxy'

ensu_gem 'sensu-plugins-redis' do
  version '3.0.1'
end

plugin_path = '/opt/sensu/embedded/bin/check-haproxy.rb'

node.override['monitor']['sudo_commands'] =
  node['monitor']['sudo_commands'] + [plugin_path]

include_recipe 'monitor::_sudo'
