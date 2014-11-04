package value_for_platform(
  ['centos', 'redhat'] => { 'default' => 'tor-core' },
  ['debian', 'ubuntu'] => { 'default' => 'tor' }
)

ruby_block "read-hostnames" do
  retries 2
  action :nothing
  block do
    #Set generated hostname for hidden services
    node.tor.HiddenServices.each do |name, service|
      path = File.join(service.HiddenServiceDir, "/hostname")
      node.normal['tor']['HiddenServices'][name]['hostname'] = File.read(path).strip()
    end
  end
end

template '/etc/tor/torrc' do
  source 'torrc.erb'
  notifies :restart, 'service[tor]', :immediately
  notifies :run, "ruby_block[read-hostnames]"
  #Set default HiddenServiceDir
  node.tor.HiddenServices.each do |name, service|
    node.default['tor']['HiddenServices'][name]['HiddenServiceDir'] = File.join("/var/lib/tor/", name, "/")
  end
end

service 'tor' do
  supports [:restart, :reload, :status]
  action [:enable, :start]
end