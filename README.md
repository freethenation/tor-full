tor-full Cookbook
============
Installs and configures tor on a node

Requirements
------------
Depends on `tor` package on debian or ubuntu and `tor-core` on centos and redhat

Attributes
----------

```ruby
#######################################
# General config section
#######################################
#The directory for keeping all the keys/etc
default['tor']['DataDirectory'] = "/var/lib/tor"
#The minimum log level to log. Possible values include debug, info, notice, warn, and err.
default['tor']['MinLogLevel'] = "notice"
#Where logs should be written. Valid values include a path to a file or "syslog"
default['tor']['LogDestination'] = "/var/log/tor/log"
#List of 'address:port' to open tor socks proxy on. Defaults to disabled
#Example: ['127.0.0.1:9050'] opens socks proxy on 9050 accessible to only the local machine
default['tor']['SocksPorts'] = []
#######################################
# Hidden Services config section
#######################################
#Desc: hidden services tor should expose
#Example:
#default['tor']['hiddenServices'] = {
# 'HIDDEN_SERVICE_NAME':{
#   'HiddenServiceDir' => '/var/lib/tor/some_service/', #default is /var/lib/tor/HIDDEN_SERVICE_NAME/
#   'HiddenServicePorts' => ['80 127.0.0.1:80'] #x y:z says to redirect requests on port x to the address y:z
#}
default['tor']['HiddenServices'] = {}
#######################################
# Relay config section
#######################################
#if true tor will act as a relay
default['tor']['relay']['enabled'] = false
#What port to advertise for incoming Tor connections
default['tor']['relay']['ORPort'] = '9001'
#The IP address or full DNS name for incoming connections to your relay.
default['tor']['relay']['Address'] = nil
#If you have multiple network interfaces, you can specify one for outgoing traffic to use
default['tor']['relay']['OutboundBindAddress'] = nil
#A handle for your relay, so people don't have to refer to it by key
default['tor']['relay']['Nickname'] = "IDidntEditTheConfig"
#Limit how much relayed traffic you will allow in kilobytes (not bits)
default['tor']['relay']['RelayBandwidthRate'] = nil
#Limit how much relayed traffic you will allow for bursts in kilobytes (not bits)
default['tor']['relay']['RelayBandwidthBurst'] = nil
#ContactInfo you can be reached at
#Example: "0xFFFFFFFF Random Person nobody AT example dot com"
default['tor']['relay']['ContactInfo'] = nil
#Sets the exit node policy for tor defaults to no exit
#Exampe: ['accept *:6660-6667','reject *:*'] # allow irc ports but no more
default['tor']['relay']['ExitPolicy'] = ['reject *:*']
#Set to 1 to run a bridge relay
default['tor']['relay']['BridgeRelay'] = 0
#Set to 0 to run a private bridge relay
default['tor']['relay']['PublishServerDescriptor'] = 1
#If true tor relay will server as a directory mirror
default['tor']['relay']['Directory'] = false
#"address:port" from which to mirror directory information
default['tor']['relay']['DirPort'] = "9030"
#If you run more than one tor node add keyids for other tor nodes
default['tor']['relay']['MyFamily'] = []
```

Usage
-----
#### tor::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `tor` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[tor]"
  ]
}
```
