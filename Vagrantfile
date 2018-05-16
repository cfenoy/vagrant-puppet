# -*- mode: ruby -*-
# vi: set ft=ruby :

domain = 'example.com'
box = 'bento/centos-7.4'
ram = 512

puppet_nodes = [
  {:hostname => 'puppet',  :ip => '172.16.32.10', :box => box, :fwdhost => 8140, :fwdguest => 8140, :ram => ram},
  {:hostname => 'client1', :ip => '172.16.32.11', :box => box},
  {:hostname => 'client2', :ip => '172.16.32.12', :box => box},
]

Vagrant.configure("2") do |config|
  puppet_nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      #node_config.vm.box_url = 'https://atlas.hashicorp.com/' + node_config.vm.box
      node_config.vm.hostname = node[:hostname] + '.' + domain
      node_config.vm.network :private_network, ip: node[:ip]

      if node[:fwdhost]
        node_config.vm.network :forwarded_port, guest: node[:fwdguest], host: node[:fwdhost]
      end

      memory = node[:ram] ? node[:ram] : 256;
      node_config.vm.provider :virtualbox do |vb|
        vb.customize [
          'modifyvm', :id,
          '--name', node[:hostname],
          '--memory', memory.to_s
        ]
      end

      config.vm.provision "shell", path: "manifests/puppet.sh"
      if node[:hostname] == "puppet"
        config.vm.provision "shell", inline: "gem query --name r10k --installed &> /dev/null || gem install -N -n /usr/bin r10k"
      end
      config.vm.synced_folder './control', '/etc/puppet/code/environments/vagrant'
      config.vm.synced_folder './puppet', '/etc/puppet/puppet'
      config.vm.synced_folder './r10k', '/etc/puppet/r10k'

      node_config.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'provision/manifests'
        puppet.module_path = 'provision/modules'
      end
    end
    #config.vm.provision "puppet"
  end
end
