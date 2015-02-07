#
# Author:: Richard Klafter <rpklafter@yahoo.com>
# Cookbook Name:: tor
# Recipe:: relay
#

node.default['tor']['relay']['enabled'] = true
include_recipe "tor-full"
