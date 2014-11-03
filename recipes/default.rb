#
# Cookbook Name:: tor
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package value_for_platform(
  ['centos', 'redhat'] => { 'default' => 'tor-core' },
  ['debian', 'ubuntu'] => { 'default' => 'tor' }
)

template '/etc/tor/torrc' do
  source 'torrc.erb'
  notifies :restart, 'service[tor]'
end

service 'tor' do
  supports [:restart, :reload, :status]
  action [:enable, :start]
end