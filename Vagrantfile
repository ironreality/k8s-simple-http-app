# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "bento/ubuntu-16.04"
  config.vm.provision "docker"
  config.vm.provision "shell", path: "k8s-provisioning.sh"

  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "172.28.128.2"
    master.vm.provision "shell", path: "k8s-cluster-init.sh"
    config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end
  end

  config.vm.define "node" do |node|
    node.vm.hostname = "node"
    node.vm.network "private_network", ip: "172.28.128.3"
    node.vm.provision "shell", path: "k8s-cluster-join.sh"
    config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
    end
  end
end

