# -*- mode: ruby -*-
# vi: set ft=ruby :
    
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "bertvv/centos72"
  config.vm.provider "virtualbox" do |vb|
	vb.gui = true
	vb.customize ['modifyvm', :id, '--cableconnected1', 'on'] 
	end
	
	$stop_firewall = <<SCRIPT
	sudo systemctl stop firewalld
SCRIPT

	$disable_firewall = <<SCRIPT
	sudo systemctl disable firewalld
SCRIPT

	$install_java = <<SCRIPT
	sudo yum install java-1.8.0-openjdk -y
SCRIPT

	$install_tomcat = <<SCRIPT
	sudo yum install tomcat tomcat-webapps tomcat-admin-webapps -y
SCRIPT

	$start_tomcat = <<SCRIPT
	sudo systemctl start tomcat
SCRIPT

	$enable_tomcat = <<SCRIPT
	sudo systemctl enable tomcat
SCRIPT
	
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  #config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #  vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  #end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
    
  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #config.vm.provision "yum", type: "shell"
  #inline: "sudo yum install git -y"
  #end
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  
  config.vm.provision "shell",
	inline: "sudo yum install mc -y"
  
  config.vm.define "apache" do |apache|
	apache.vm.hostname = "apache"
	apache.vm.network "private_network", ip: "192.168.0.10"
	apache.vm.network "forwarded_port", guest: 80, host: 21080
	
		apache.vm.provision "install httpd", type: "shell",
		inline: "sudo yum install httpd -y"
		
		apache.vm.provision "start service httpd", type: "shell",
		inline: "sudo systemctl enable httpd"
		
		apache.vm.provision "start httpd", type: "shell",
		inline: "sudo systemctl start httpd"
		
		apache.vm.provision "stop_firewall", type: "shell",
		inline: $stop_firewall
		
		apache.vm.provision "disable_firewall", type: "shell",
		inline: $disable_firewall
	
		#apache.vm.provision "yum", type: "shell",
		#inline: "sudo yum install git -y"

		#apache.vm.provision "git clone", type: "shell",
		#inline: "git clone https://github.com/dmitrij-ukrainets/du_devops_training.git"

		#apache.vm.provision "git checkout", type: "shell",
		#inline: "cd du_devops_training&&git checkout task1"
 
		#apache.vm.provision "git branch check", type: "shell",
		#inline: "cd du_devops_training&&git branch"
  
		apache.vm.provision "get ip", type: "shell",
		inline: "ip addr > /vagrant/apache-ip.txt"
  end

  config.vm.define "tomcat01" do |tomcat01|
	tomcat01.vm.hostname = "tomcat01"
	tomcat01.vm.network "private_network", ip: "192.168.0.11"
	tomcat01.vm.network "forwarded_port", guest: 8080, host: 21081
	
		tomcat01.vm.provision "install java", type: "shell",
		inline: $install_java
		
		tomcat01.vm.provision "install tomcat", type: "shell",
		inline: $install_tomcat
		
		tomcat01.vm.provision "start tomcat", type: "shell",
		inline: $start_tomcat
		
		tomcat01.vm.provision "enable tomcat", type: "shell",
		inline: $enable_tomcat
	
		tomcat01.vm.provision "stop_firewall", type: "shell",
		inline: $stop_firewall
		
		tomcat01.vm.provision "disable_firewall", type: "shell",
		inline: $disable_firewall
  
		tomcat01.vm.provision "get ip", type: "shell",
		inline: "ip addr > /vagrant/tomcat01-ip.txt"
  end
    config.vm.define "tomcat02" do |tomcat02|
	tomcat02.vm.hostname = "tomcat02"
	tomcat02.vm.network "private_network", ip: "192.168.0.12"
	tomcat02.vm.network "forwarded_port", guest: 8080, host: 21082
	
		tomcat02.vm.provision "install java", type: "shell",
		inline: $install_java
		
		tomcat02.vm.provision "install tomcat", type: "shell",
		inline: $install_tomcat
		
		tomcat02.vm.provision "start tomcat", type: "shell",
		inline: $start_tomcat
		
		tomcat02.vm.provision "enable tomcat", type: "shell",
		inline: $enable_tomcat
	
		tomcat02.vm.provision "stop_firewall", type: "shell",
		inline: $stop_firewall
		
		tomcat02.vm.provision "disable_firewall", type: "shell",
		inline: $disable_firewall	
  
		tomcat02.vm.provision "get ip", type: "shell",
		inline: "ip addr > /vagrant/tomcat02-ip.txt"
  end
end
