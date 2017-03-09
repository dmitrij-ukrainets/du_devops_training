# -*- mode: ruby -*-
# vi: set ft=ruby :
    
Vagrant.configure("2") do |config|

  config.vm.box = "bertvv/centos72"
  config.vm.provider "virtualbox" do |vb|
	#vb.gui = true
	vb.customize ['modifyvm', :id, '--cableconnected1', 'on'] 
	end
	
$stop_firewall = <<SCRIPT
sudo systemctl stop firewalld
sudo systemctl disable firewalld
SCRIPT

$install_httpd = <<SCRIPT
sudo yum install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd
SCRIPT

$install_java = <<SCRIPT
sudo yum install java-1.8.0-openjdk -y
SCRIPT

$install_oracle_java = <<SCRIPT
sudo yum localinstall /vagrant/jdk-8u121-linux-x64.rpm -y
SCRIPT

$install_jenkins = <<SCRIPT
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install jenkins -y
sudo service jenkins start
sudo chkconfig jenkins on
SCRIPT

$install_nexus = <<SCRIPT
sudo cp /vagrant/nexus-3.2.0-01-unix.tar.gz /usr/local
sudo tar -xvzf /usr/local/nexus-3.2.0-01-unix.tar.gz
sudo mv /home/vagrant/nexus-3.2.0-01 /usr/local
sudo mv /home/vagrant/sonatype-work /usr/local
sudo ln -s /usr/local/nexus-3.2.0-01 /usr/local/nexus
SCRIPT

$restart_httpd = <<SCRIPT
sudo systemctl restart httpd
SCRIPT

$stop_httpd = <<SCRIPT
sudo systemctl stop httpd
sudo systemctl disable httpd
SCRIPT

$configure_mod_jk = <<SCRIPT
sudo echo "worker.list=lb
worker.lb.type=lb
worker.lb.balance_workers=tomcat01, tomcat02
worker.tomcat01.host=192.168.0.11
worker.tomcat01.port=8009
worker.tomcat01.type=ajp13
worker.tomcat02.host=192.168.0.12
worker.tomcat02.port=8009
worker.tomcat02.type=ajp13
worker.list=status
worker.status.type=status" > /etc/httpd/conf/workers.properties
SCRIPT

$configure_httpd_lb = <<SCRIPT
sudo echo "LoadModule jk_module modules/mod_jk.so
JkWorkersFile conf/workers.properties
JkShmFile /tmp/shm
JkLogFile logs/mod_jk.log
JkLogLevel info
JkMount /task2* lb
JkMount /jk-status status" >> /etc/httpd/conf/httpd.conf
SCRIPT

$install_chef_server = <<SCRIPT
sudo rpm -Uvh /vagrant/chef-server-core-12.13.0-1.el7.x86_64.rpm
sudo chef-server-ctl reconfigure
sudo chef-server-ctl user-create du Dmitrij Ukrainets Dmitrij_Ukrainets@epam.com '1q2w3e' --filename /home/vagrant/du.pem
sudo chef-server-ctl org-create task5 'Task_5, task.' --association_user du --filename /home/vagrant/task5-validator.pem
sudo chef-server-ctl install chef-manage
sudo chef-server-ctl reconfigure
sudo chef-manage-ctl reconfigure --accept-license
sudo chef-server-ctl install opscode-push-jobs-server
sudo chef-server-ctl reconfigure
sudo opscode-push-jobs-server-ctl reconfigure
sudo chef-server-ctl install opscode-reporting
sudo chef-server-ctl reconfigure
sudo opscode-reporting-ctl reconfigure --accept-license
SCRIPT

$install_chef_dk = <<SCRIPT
sudo rpm -Uvh /vagrant/chefdk-1.2.22-1.el7.x86_64.rpm
chef verify
echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
source ~/.bash_profile
which ruby > ~/ruby-test.txt
SCRIPT

$where_chef = <<SCRIPT
sudo echo "192.168.0.10 apache >> /etc/hosts"
SCRIPT
	
	config.vm.provision "shell",
	inline: "sudo yum install mc -y"
	
	config.vm.provision "stop_firewall", type: "shell",
	inline: $stop_firewall
  
  config.vm.define "apache" do |apache|
	apache.vm.hostname = "apache"
	apache.vm.network "private_network", ip: "192.168.0.10"
		apache.vm.provider "virtualbox" do |vb|
		vb.customize ['modifyvm', :id, "--memory", "2048"]
	end
			
		apache.vm.provision "install httpd", type: "shell",
		inline: $install_httpd
		
		apache.vm.provision "stop httpd", type: "shell",
		inline: $stop_httpd
		
#		apache.vm.provision "add mod_jk connector", type: "shell",
#		inline: "sudo cp /vagrant/mod_jk.so /etc/httpd/modules/"
		
#		apache.vm.provision "configure_mod_jk", type: "shell",
#		inline: $configure_mod_jk
		
#		apache.vm.provision "configure_httpd_lb", type: "shell",
#		inline: $configure_httpd_lb
		
#		apache.vm.provision "restart_httpd", type: "shell",
#		inline: $restart_httpd
		
		apache.vm.provision "yum", type: "shell",
		inline: "sudo yum install git -y"
		
		apache.vm.provision "git clone", type: "shell",
		inline: "git clone https://github.com/dmitrij-ukrainets/du_devops_training.git"
		
		apache.vm.provision "git checkout", type: "shell",
		inline: "cd du_devops_training&&git checkout task5"
		
		apache.vm.provision "install oracle java", type: "shell",
		inline: $install_oracle_java

		apache.vm.provision "install jenkins", type: "shell",
		inline: $install_jenkins
	
		apache.vm.provision "$install nexus", type: "shell",
		inline: $install_nexus
		
		apache.vm.provision "$install screen", type: "shell",
		inline: "sudo yum install screen -y"
		
		apache.vm.provision "$install chef server", type: "shell",
		inline: $install_chef_server
		
		apache.vm.provision "$install chef dk", type: "shell",
		inline: $install_chef_dk

#		#apache.vm.provision "get ip", type: "shell",
#		#inline: "ip addr > /vagrant/apache-ip.txt"
		
	end

  config.vm.define "tomcat01" do |tomcat01|
	tomcat01.vm.hostname = "tomcat01"
	tomcat01.vm.network "private_network", ip: "192.168.0.11"
		tomcat01.vm.provider "virtualbox" do |vb|
		vb.customize ['modifyvm', :id, "--memory", "512"]
	end
	
		tomcat01.vm.provision "install java", type: "shell",
		inline: $install_oracle_java
		
		tomcat01.vm.provision "locate chef server", type: "shell",
		inline: $where_chef
 
		#tomcat01.vm.provision "get ip", type: "shell",
		#inline: "ip addr > /vagrant/tomcat01-ip.txt"
	end
   config.vm.define "tomcat02" do |tomcat02|
	tomcat02.vm.hostname = "tomcat02"
	tomcat02.vm.network "private_network", ip: "192.168.0.12"
		tomcat02.vm.provider "virtualbox" do |vb|
		vb.customize ['modifyvm', :id, "--memory", "512"]
	end
		tomcat02.vm.provision "install java", type: "shell",
		inline: $install_oracle_java

		tomcat02.vm.provision "locate chef server", type: "shell",
		inline: $where_chef
		
#		#tomcat02.vm.provision "get ip", type: "shell",
#		#inline: "ip addr > /vagrant/tomcat02-ip.txt"
	end
end
