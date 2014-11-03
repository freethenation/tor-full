#######################################
# Socks config section
#######################################
#if true tor will open a socks proxy
default['tor']['socks']['enabled'] = false
#list of 'address:port' to open tor socks proxy on. A port of'0' means no socks proxy
default['tor']['socks']['SocksPort'] = ['0.0.0.0:9050']
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
#ContactInfo you can be reached at. exp "0xFFFFFFFF Random Person nobody AT example dot com"
default['tor']['relay']['ContactInfo'] = nil
#Sets the exit node policy for tor defaults to no exit
#Exampe: ['accept *:6660-6667','reject *:*'] # allow irc ports but no more
default['tor']['relay']['ExitPolicy'] = ['reject *:*']
#Set to 1 to run a bridge relay
default['tor']['relay']['BridgeRelay'] = 0
#Set to 0 to run a private bridge relay
default['tor']['relay']['PublishServerDescriptor'] = 1
