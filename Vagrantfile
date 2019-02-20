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

  config.vm.define "puppet-server" do |vm1|
  
    # 1- Box Settings
    
    vm1.vm.box              = "generic/ubuntu1604"
    vm1.vm.hostname         = "puppet.example.local"
    vm1.vm.box_check_update = true
   
    vm1.vm.provider :kvm do |domain|
      domain.memory_size    = 3072
      domain.cpus           = 2
    end
  
    # 2- Network Settings

    vm1.vm.network :private_network,
                    ip: '192.168.10.10',
                    libvirt_netmask: '255.255.255.0',
                    libvirt__network_name: 'vagrant-lab',
                    autostart: true,
                    libvirt__domain_name: 'example.local',
                    libvirt__forward_mode: 'route',
                    libvirt__dhcp_enabled: false                    
  
                    
    vm1.vm.provision "shell", :inline => <<-SHELL
      sudo apt-get install -y ntp ntpdate
      sudo ntpdate -u 0.ubuntu.pool.ntp.org
      sudo timedatectl set-timezone America/Santiago
      sudo echo "192.168.10.10 puppet.example.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.20 lbalancer.example.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.30 web01.example.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.40 web02.example.local" | sudo tee -a /etc/hosts
      wget --no-check-certificate -c https://apt.puppetlabs.com/puppet5-release-xenial.deb -O /tmp/puppet.deb
      dpkg -i /tmp/puppet.deb
      apt-get update
      apt-get install -y puppetserver
      sudo awk '{sub(/-Xms2g -Xmx2g/,"-Xms512m -Xmx512m")}1' /etc/default/puppetserver > tmp.txt && mv tmp.txt /etc/default/puppetserver
      sudo echo -e "ndns_alt_names = puppet.example.local,server" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
      sudo echo "" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
      sudo echo -e "[main]\ncertname = puppet.example.local\nserver = puppet.example.local\nenvironment = production\nruninterval = 15m" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
      sudo locale-gen es_CL
      sudo systemctl enable puppetserver
      sudo systemctl start puppetserver
      SHELL
      #sudo sleep 20
      #sudo /opt/puppetlabs/bin/puppet cert sign --all
       
   # 3- Shared Folder

  config.vm.synced_folder "puppet/manifest", "/etc/puppetlabs/code/environments/production/manifests", type:"nfs", nfs_version: 4, nfs_udp: false
  config.vm.synced_folder "puppet/modules", "/etc/puppetlabs/code/environments/production/modules", type:"nfs", nfs_version: 4, nfs_udp: false
  #config.vm.synced_folder "html", "/var/www/html", type:"nfs", nfs_version: 4, nfs_udp: false


  end

##### MAQUINA 2 ###

  config.vm.define "lbalancer" do |vm2|
  
    # 1- Box Settings
    
    vm2.vm.box              = "generic/ubuntu1604"
    vm2.vm.hostname         = "lbalancer.example.local"
    vm2.vm.box_check_update = true   
    
    vm2.vm.provider :kvm do |domain|
      domain.memory_size    = 2048
      domain.cpus           = 1
    end
  
    # 2- Network Settings

    vm2.vm.network :private_network,
                   ip: '192.168.10.20',
                    libvirt_netmask: '255.255.255.0',
                    libvirt__network_name: 'vagrant-lab',
                   autostart: true,
                    libvirt__domain_name: 'example.local',
                    libvirt__forward_mode: 'route',
                    libvirt__dhcp_enabled: false
 
    vm2.vm.provision "shell", :inline => <<-SHELL      
      sudo apt-get install -y ntp ntpdate
      sudo ntpdate -u 0.ubuntu.pool.ntp.org
      sudo timedatectl set-timezone America/Santiago
      sudo echo "192.168.10.10 puppet.example.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.20 lbalancer.example.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.30 web01.example.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.40 web02.example.local" | sudo tee -a /etc/hosts
      wget --no-check-certificate -c https://apt.puppetlabs.com/puppet5-release-xenial.deb -O /tmp/puppet.deb
      dpkg -i /tmp/puppet.deb
      apt-get update
      apt-get install -y puppet-agent
      apt-get install -y git
      sudo echo -e "[main]\ncertname = lbalancer.example.local\nserver = puppet.example.local\nenvironment = production\nruninterval = 15m" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
      sudo locale-gen es_CL
      sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
      sudo /opt/puppetlabs/bin/puppet agent -t
    SHELL
  end

##### MAQUINA 3 ###

  config.vm.define "web01" do |vm3|
    
    # 1- Box Settings
    
    vm3.vm.box              = "generic/ubuntu1604"
    vm3.vm.hostname         = "web01.example.local"
    vm3.vm.box_check_update = true   
    
    vm3.vm.provider :kvm do |domain|
      domain.memory_size    = 2048
      domain.cpus           = 1
    end

    # 2- Network Settings

    vm3.vm.network :private_network,
                  ip: '192.168.10.30',
                    libvirt_netmask: '255.255.255.0',
                    libvirt__network_name: 'vagrant-lab',
                  autostart: true,
                    libvirt__domain_name: 'example.local',
                    libvirt__forward_mode: 'route',
                    libvirt__dhcp_enabled: false

    vm3.vm.provision "shell", :inline => <<-SHELL      
      sudo apt-get install -y ntp ntpdate
      sudo ntpdate -u 0.ubuntu.pool.ntp.org
      sudo timedatectl set-timezone America/Santiago
      sudo echo "192.168.10.10 puppet.example.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.20 lbalancer.example.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.30 web01.example.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.40 web02.example.local" | sudo tee -a /etc/hosts
      wget --no-check-certificate -c https://apt.puppetlabs.com/puppet5-release-xenial.deb -O /tmp/puppet.deb
      dpkg -i /tmp/puppet.deb
      apt-get update
      apt-get install -y puppet-agent
      apt-get install -y git
      sudo echo -e "[main]\ncertname = web01.example.local\nserver = puppet.example.local\nenvironment = production\nruninterval = 15m" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
      sudo locale-gen es_CL
      sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
      sudo /opt/puppetlabs/bin/puppet agent -t
    SHELL
  end

##### MAQUINA 4 ###

  config.vm.define "web02" do |vm4|
    
    # 1- Box Settings
    
    vm4.vm.box              = "generic/ubuntu1604"
    vm4.vm.hostname         = "web02.example.local"
    vm4.vm.box_check_update = true   
    
    vm4.vm.provider :kvm do |domain|
      domain.memory_size    = 2048
      domain.cpus           = 1
    end

    # 2- Network Settings

    vm4.vm.network :private_network,
                  ip: '192.168.10.40',
                    libvirt_netmask: '255.255.255.0',
                    libvirt__network_name: 'vagrant-lab',
                  autostart: true,
                    libvirt__domain_name: 'example.local',
                    libvirt__forward_mode: 'route',
                    libvirt__dhcp_enabled: false

    vm4.vm.provision "shell", :inline => <<-SHELL      
      sudo apt-get install -y ntp ntpdate
      sudo ntpdate -u 0.ubuntu.pool.ntp.org
      sudo timedatectl set-timezone America/Santiago
      sudo echo "192.168.10.10 puppet.example.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.20 lbalancer.example.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.30 web01.example.local" | sudo tee -a /etc/hosts
      sudo echo "192.168.10.40 web02.example.local" | sudo tee -a /etc/hosts
      wget --no-check-certificate -c https://apt.puppetlabs.com/puppet5-release-xenial.deb -O /tmp/puppet.deb
      dpkg -i /tmp/puppet.deb
      apt-get update
      apt-get install -y puppet-agent
      apt-get install -y git
      sudo echo -e "[main]\ncertname = web02.example.local\nserver = puppet.example.local\nenvironment = production\nruninterval = 15m" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
      sudo locale-gen es_CL
      sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
      sudo /opt/puppetlabs/bin/puppet agent -t
    SHELL
  end

end

## Sign Certs in Puppet Server
# sudo /opt/puppetlabs/bin/puppet cert sign -a

## Get update in Puppet node
# sudo /opt/puppetlabs/bin/puppet agent -t

