#
# Cookbook Name:: monitor
# Recipe:: default
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

include_recipe 'monitor::_master_search'

include_recipe 'sensu::default'

ip_type = node['monitor']['use_local_ipv4'] ? 'local_ipv4' : 'public_ipv4'

client_attributes = node['monitor']['additional_client_attributes'].to_hash

client_name = node.name

if node.key?('ec2')
  %w(
    ami_id
    instance_id
    instance_type
    placement_availability_zone
    kernel_id
    profile
  ).each do |id|
    key = "ec2_#{id}"
    key = 'ec2_av_zone' if id == 'placement_availability_zone'

    client_attributes[key] = node['ec2'][id]
  end
  region = node['ec2']['placement_availability_zone'][0..-2]
  client_attributes['aws_management_console'] = "https://#{region}.console.aws.amazon.com/ec2/v2/home?region=#{region}#Instances:search=#{node['ec2']['instance_id']};sort=Name"
end

if node.key?('cloud')
  %w(
    local_ipv4
    public_ipv4
    provider
    public_hostname
  ).each do |id|
    key = "cloud_#{id}"

    client_attributes[key] = node['cloud'][id]
  end

end

%w(
  chef_environment
  platform
  platform_version
  platform_family
).each do |key|
  client_attributes[key] = node[key] if node.key?(key)
end

%w(
  scheme_prefix
  remedy_app
  remedy_group
  remedy_component
).each do |key|
  next unless node['monitor'].key?(key)
  client_attributes[key] = node['monitor'][key] if node['monitor'][key]
end

node.override['sensu']['name'] = client_name

sensu_client client_name do
  if node.key?('cloud')
    address node['cloud'][ip_type] || node['ipaddress']
  else
    address node['ipaddress']
  end
  subscriptions node['roles'] + [node['os'], 'all']
  additional client_attributes
end

include_recipe 'monitor::_nagios_plugins' if node['monitor']['use_nagios_plugins']
include_recipe 'monitor::_system_profile' if node['monitor']['use_system_profile']
include_recipe 'monitor::_statsd' if node['monitor']['use_statsd_input']

include_recipe 'sensu::client_service'
