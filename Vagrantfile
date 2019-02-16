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
                    ip: '192.168.1.10',
                    libvirt_netmask: '255.255.255.0',
                    libvirt__network_name: 'test3',
                    autostart: true,
                    libvirt__domain_name: 'example.com',
                    libvirt__forward_mode: 'route',
                    libvirt__dhcp_enabled: false                    
  
                    
    vm1.vm.provision "shell", :inline => <<-SHELL
      sudo apt-get install -y ntp ntpdate
      sudo ntpdate -u 0.ubuntu.pool.ntp.org
      sudo timedatectl set-timezone America/Santiago
      sudo echo "192.168.1.10 server.itzgeek.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.1.20 client.itzgeek.local" | sudo tee -a /etc/hosts
      SHELL
    end

    #vm1.vm.provision "shell", :inline => <<-SHELL

      #wget https://apt.puppetlabs.com/puppet5-release-stretch.deb
      #sudo dpkg -i puppet5-release-stretch.deb
      #sudo apt-get update
      #sudo apt-get install -y puppetserver

      #sudo echo "" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
      #sudo echo -e "[main]\ncertname = server.itzgeek.local\nserver = server.itzgeek.local\nenvironment = production\nruninterval = 15m" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
      #sudo systemctl start puppetserver
      #sudo systemctl enable puppetserver
 #   SHELL
 # end

##### MAQUINA 2 ###

  config.vm.define "node2" do |vm2|
  
    # 1- Box Settings
    
    vm2.vm.box              = "generic/ubuntu1604"
    vm2.vm.hostname         = "client.itzgeek.local"
    vm2.vm.box_check_update = true   
    
    vm2.vm.provider :kvm do |domain|
      domain.memory_size    = 2048
      domain.cpus           = 2
    end
  
    # 2- Network Settings

    vm2.vm.network :private_network,
                    ip: '192.168.1.20',
                    libvirt_netmask: '255.255.255.0',
                    libvirt__network_name: 'test3',
                    autostart: true,
                    libvirt__domain_name: 'example.com',
                    libvirt__forward_mode: 'route',
                    libvirt__dhcp_enabled: false
 
    vm2.vm.provision "shell", :inline => <<-SHELL      
      sudo apt-get install -y ntp ntpdate
      sudo ntpdate -u 0.ubuntu.pool.ntp.org
      sudo timedatectl set-timezone America/Santiago
      sudo echo "192.168.1.10 server.itzgeek.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.1.20 client.itzgeek.local" | sudo tee -a /etc/hosts
      #wget https://apt.puppetlabs.com/puppet5-release-stretch.deb
      #sudo dpkg -i puppet5-release-stretch.deb
      #sudo apt-get update
      #sudo apt-get install -y puppet-agent
      #sudo echo "dns_alt_names = server.itzgeek.local,server" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
      SHELL
    end
end

