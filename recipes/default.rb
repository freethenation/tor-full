#
# Author:: Richard Klafter (<rpklafter@yahoo.com>)
# Cookbook Name:: tor
# Recipe:: default
#

case node['platform_family']
# Debian / Ubuntu
when 'debian'
  include_recipe 'apt'

  # Add TorProject.org repository
  apt_repository 'tor' do
    uri          'http://deb.torproject.org/torproject.org'
    distribution node['lsb']['codename']
    components   ['main']
    keyserver    'keys.gnupg.net'
    key          'A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89'
    deb_src      true
  end

  # Install Tor
  package 'tor'

# RHEL / Fedora
when 'rhel', 'fedora'
  include_recipe 'yum'

  # Add TorProject.org repository
  platformShort = node['platform_family'] == 'rhel' ? 'el' : 'fc'
  intVersion = node['platform_version'].to_i
  yum_repository 'tor' do
    description "Tor Stable repo"
    baseurl "https://deb.torproject.org/torproject.org/rpm/#{platformShort}/#{intVersion}/$basearch/"
    gpgkey 'https://deb.torproject.org/torproject.org/rpm/RPM-GPG-KEY-torproject.org.asc'
    action :create
  end
  yum_repository 'tor-source' do
    description "Tor Source repo"
    baseurl "https://deb.torproject.org/torproject.org/rpm/#{platformShort}/#{intVersion}/SRPMS/"
    gpgkey 'https://deb.torproject.org/torproject.org/rpm/RPM-GPG-KEY-torproject.org.asc'
    action :create
  end

  # Exclude platform Tor package
  if node['platform_family'] == 'rhel' then
    yum_repository 'epel' do
      description 'Extra Packages for Enterprise Linux'
      mirrorlist 'https://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
      gpgkey 'https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
      exclude 'tor'
      action :create
    end
  elsif node['platform_family'] == 'fedora' then
    yum_repository 'fedora' do
      description 'Fedora'
      mirrorlist 'https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch'
      gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch'
      exclude 'tor'
      action :create
    end
  end

  # Install Tor
  package 'tor'

# TODO: support Mac using homebrew
# when 'mac_os_x'
end

# Configure hidden services
ruby_block "read-hostnames" do
  retries 2
  action :nothing
  block do
    # Set generated hostname for hidden services
    node.tor.HiddenServices.each do |name, service|
      path = File.join(service.HiddenServiceDir, "/hostname")
      node.normal['tor']['HiddenServices'][name]['hostname'] = File.read(path).strip()
    end
  end
end

# Build torrc configuration file
template '/etc/tor/torrc' do
  source 'torrc.erb'
  notifies :restart, 'service[tor]', :immediately
  notifies :run, "ruby_block[read-hostnames]"
  # Set default HiddenServiceDir
  node.tor.HiddenServices.each do |name, service|
    node.default['tor']['HiddenServices'][name]['HiddenServiceDir'] = File.join("/var/lib/tor/", name, "/")
  end
end

# Install exit policy notice
template '/etc/tor/tor-exit-notice.html' do
  source 'tor-exit-notice.html.erb'
end

service 'tor' do
  supports [:restart, :reload, :status]
  action [:enable, :start]
end