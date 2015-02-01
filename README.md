Description
===========

Installs Tor and optionally sets up a hidden service or configures as a relay

Requirements
============
## Ohai and Chef:

* Ohai: 6.14.0+

This cookbook makes use of `node['platform_family']` to simplify platform
selection logic. This attribute was introduced in Ohai v0.6.12.

## Platform:

The following platform families are supported:

* Debian
* RHEL
* Fedora

## Cookbooks:

* apt (for Debian installation)
* yum (for RHEL 5 installation)

## Attributes

### General config section
* `node['tor']['DataDirectory']` - The directory for keeping all the keys/etc
* `node['tor']['MinLogLevel']` - The minimum log level to log. Possible values include debug, info, notice, warn, and err.
* `node['tor']['LogDestination']` - Where logs should be written. Valid values include a path to a file or "syslog"
* `node['tor']['SocksPorts']` - List of 'address:port' to open tor socks proxy on. Defaults to disabled

### Hidden Services config section

* `node['tor']['HiddenServices']` - hidden services Tor should expose
  ```ruby
  	# Example
  	# default['tor']['hiddenServices'] = {
	# 'HIDDEN_SERVICE_NAME':{
	#   'HiddenServiceDir' => '/var/lib/tor/some_service/', #default is /var/lib/tor/HIDDEN_SERVICE_NAME/
	#   'HiddenServicePorts' => ['80 127.0.0.1:80'] #x y:z says to redirect requests on port x to the address y:z
	# }
  ```

### Relay config section

* `node['tor']['relay']['enabled']` - if true tor will act as a relay
* `node['tor']['relay']['ORPort']` - What port to advertise for incoming Tor connections
* `node['tor']['relay']['Address']` - The IP address or full DNS name for incoming connections to your relay
* `node['tor']['relay']['OutboundBindAddress']` - If you have multiple network interfaces, you can specify one for outgoing traffic to use
* `node['tor']['relay']['Nickname']` - A handle for your relay, so people don't have to refer to it by key
* `node['tor']['relay']['RelayBandwidthRate']` - Limit how much relayed traffic you will allow in kilobytes (not bits)
* `node['tor']['relay']['RelayBandwidthBurst']` - Limit how much relayed traffic you will allow for bursts in kilobytes (not bits)
* `node['tor']['relay']['ContactInfo']` - ContactInfo you can be reached at
  * Example: "0xFFFFFFFF Random Person nobody AT example dot com"
* `node['tor']['relay']['ExitPolicy']` - Sets the exit node policy for tor defaults to no exit
  * Exampe: ['accept *:6660-6667','reject *:*'] # allow irc ports but no more
* `node['tor']['relay']['BridgeRelay']` - Set to 1 to run a bridge relay
* `node['tor']['relay']['PublishServerDescriptor']` - Set to 0 to run a private bridge relay
* `node['tor']['relay']['Directory']` - If true tor relay will server as a directory mirror
* `node['tor']['relay']['DirPort']` - "address:port" from which to mirror directory information
* `node['tor']['relay']['DirPortFrontPage']` - If true a blob of html will be returned on your DirPort explaining Tor.
  * To send a custom HTML blob specify its full path, example "/etc/tor/tor-exit-notice.html"
* `node['tor']['relay']['MyFamily']` - If you run more than one tor node add keyids for other tor nodes

Recipes
=======

## tor-full::default

Installs Tor and enables Tor service. By default it will not open a socks proxy, offer a hidden service,
or act as a relay.

## tor-full::relay

Installs Tor and configs Tor to be a relay. By default the relay will not be an exit or directory.
Make sure to read through the attributes section for relays above.

Usage
=====

This cookbook primarily installs Tor core packages. It can also be
used to run a Tor relay or a hidden service.

To install tor client (all supported platforms):

    include_recipe 'tor'

To install tor relay:

    include_recipe "tor::relay"

Examples
-----
### Open local socks port
The example role below opens a Tor socks proxy on port 9050 available to localhost only

```ruby
name "torproxy"
run_list("recipe[tor-full]")
override_attributes(
  "tor" => {
    "SocksPorts" => ["127.0.0.1:9050"]
  }
)
```

### Hidden service on port 80
The example role below serves a website on port 80 as a hidden service. 

```ruby
name "torservice"
run_list("recipe[tor-full]")
override_attributes(
  "tor" => {
    "hiddenServices" => {
      "hidden_web_service" => {
       "HiddenServicePorts" => ["80 127.0.0.1:8080"]
       #requests on port 80 are redirected to localhost port 8080
      }
    }
  }
)
```

Note: The `tor-full` recipe will write the hidden service's hostname to the attribute `node.tor.hiddenServices.HIDDEN_SERVICE_NAME.hostname` after node convergence.

### Tor Relay
The node config below sets up a Tor relay. The relay is a directory and an exit
for IRC (ports 6660 & 6667).

```json
{
  "run_list": [
    "recipe[tor-full::relay]"
  ],
  "tor": { 
    "relay": {
      "Address":"tor.icyego.com",
      "Nickname":"IcyEgo",
      "RelayBandwidthRate":"1000",
      "RelayBandwidthBurst":"1100",
      "ContactInfo":"ContactInfo 0x04FAC2E9CC21424A Richard Klafter <rpklafter@yahoo.com>",
      "Directory":true,
      "ExitPolicy":["accept *:6660-6667","reject *:*"]
    }
  }
}

```

Note: you can make `recipe[tor-full]` behave like `recipe[tor-full::relay]` by 
setting the attribute `tor.relay.enabled = true`.

License and Author
==================

- Author:: Richard Klafter (<rpklafter@yahoo.com>)
- License:: MIT
