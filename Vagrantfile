# -*- mode: ruby -*-
# vi: set ft=ruby :

master_ip = "172.28.128.2"

nodes = {
	"node1" => "172.28.128.3",
	#"node2" => "172.28.128.4"
}

Vagrant.configure(2) do |config|

  config.vm.box = "bento/ubuntu-16.04"

  config.vm.provision "docker"
  config.vm.provision "shell", path: "k8s-provisioning.sh"

	# master configuration
  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: master_ip
    master.vm.provision "shell", path: "k8s-cluster-init.sh"
    config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end
  end

	# nodes configuration
  nodes.each do |name, ip|
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network "private_network", ip: ip
      node.vm.provision "shell", path: "k8s-cluster-join.sh"
      config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 2
      end
    end
  end
end

