#
# Cookbook Name:: monitor
# Recipe:: _slack_node_handler
#

sensu_gem 'sensu-plugins-slack' do
  version '3.1.1'
end

cookbook_file '/tmp/slack.erb' do
  source 'slack.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

sensu_snippet 'slack' do
  content(
    webhook_url: node['monitor']['handlers']['slack']['webhook_url'],
    channel: node['monitor']['handlers']['slack']['channel'],
    bot_name: node['monitor']['handlers']['slack']['bot_name'],
    fields: node['monitor']['handlers']['slack']['fields'],
    template: '/tmp/slack.erb'
  )
end

sensu_handler 'slack' do
  type 'pipe'
  command 'handler-slack.rb'
  severities %w[ok critical unknown]
  timeout node['monitor']['default_handler_timeout']
  filters ['occurrences', 'chef_env_filter']
end
