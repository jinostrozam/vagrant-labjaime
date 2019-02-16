# -*k mode: ruby -*-
# vi: set ft=ruby :

# General Config

Vagrant.configure("2") do |config|
  
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver        = 'kvm'
    libvirt.random model: 'random'
    libvirt.cpu_mode      = 'host-passthrough'
    libvirt.driver        = 'kvm'
  end
  
##### MAQUINA 1 ###

  config.vm.define "node1" do |vm1|
  
    # 1- Box Settings
    
    vm1.vm.box              = "generic/ubuntu1604"
    vm1.vm.hostname         = "server.itzgeek.local"
    vm1.vm.box_check_update = true
   
    vm1.vm.provider :kvm do |domain|
      domain.memory_size    = 3072
      domain.cpus           = 2
    end
  
    # 2- Network Settings

    vm1.vm.network :private_network,
                    ip: '192.168.10.10',
                    libvirt_netmask: '255.255.255.0',
                    libvirt__network_name: 'vagrant-jai',
                    autostart: true,
                    libvirt__domain_name: 'example.com',
                    libvirt__forward_mode: 'route',
                    libvirt__dhcp_enabled: false                    
  
                    
    vm1.vm.provision "shell", :inline => <<-SHELL
      sudo apt-get install -y ntp ntpdate
      sudo ntpdate -u 0.ubuntu.pool.ntp.org
      sudo timedatectl set-timezone America/Santiago
      sudo echo "192.168.10.10 server.itzgeek.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.20 client.itzgeek.local" | sudo tee -a /etc/hosts
      wget --no-check-certificate -c https://apt.puppetlabs.com/puppet5-release-xenial.deb -O /tmp/puppet.deb
      dpkg -i /tmp/puppet.deb
      apt-get update
      apt-get install -y puppetserver
      sudo awk '{sub(/-Xms2g -Xmx2g/,"-Xms512m -Xmx512m")}1' /etc/default/puppetserver > tmp.txt && mv tmp.txt /etc/default/puppetserver
      sudo echo "" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
      sudo echo -e "ndns_alt_names = server.itzgeek.local,server" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
      sudo echo -e "[main]\ncertname = server.itzgeek.local\nserver = server.itzgeek.local\nenvironment = production\nruninterval = 15m" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
      sudo locale-gen es_CL
      sudo systemctl enable puppetserver
      sudo systemctl start puppetserver
      SHELL
 
   
  end

##### MAQUINA 2 ###

#  config.vm.define "node2" do |vm2|
#  
#    # 1- Box Settings
#    
#    vm2.vm.box              = "generic/ubuntu1604"
#    vm2.vm.hostname         = "client.itzgeek.local"
#    vm2.vm.box_check_update = true   
#    
#    vm2.vm.provider :kvm do |domain|
#      domain.memory_size    = 2048
#      domain.cpus           = 2
#    end
#  
#    # 2- Network Settings
#
#    vm2.vm.network :private_network,
#                   ip: '192.168.10.20',
#                    libvirt_netmask: '255.255.255.0',
#                    libvirt__network_name: 'vagrant-jai',
#                   autostart: true,
#                    libvirt__domain_name: 'example.com',
#                    libvirt__forward_mode: 'route',
#                    libvirt__dhcp_enabled: false
# 
#    vm2.vm.provision "shell", :inline => <<-SHELL      
#      sudo apt-get install -y ntp ntpdate
#      sudo ntpdate -u 0.ubuntu.pool.ntp.org
#      sudo timedatectl set-timezone America/Santiago
#      sudo echo "192.168.10.10 server.itzgeek.local" | sudo tee -a /etc/hosts
#      sudo echo "192.168.10.20 client.itzgeek.local" | sudo tee -a /etc/hosts
#      #wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
#      #sudo dpkg -i puppet5-release-xenial.deb
#      #sudo apt update
#      #sudo apt-get install -y puppet-agent
#      #sudo echo "" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
#      #sudo echo -e "[main]\ncertname = client.itzgeek.local\nserver = server.itzgeek.local\nenvironment = production\nruninterval = 15m" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
#      #sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
#      SHELL
#    end
end
