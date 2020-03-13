# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "walidsaad/RancherOS"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provider "virtualbox" do |vb|
      vb.check_guest_additions = false
      # If the host has a functional vboxsf filesystem
      vb.functional_vboxsf = false
      # Customize the amount of memory on the VM:
      vb.memory = "1280"
  end

  # SSH Configuration
  config.ssh.username = "rancher"
  config.ssh.keys_only = true

  # Stop vagrant-vbguest installing Guest Additions
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.no_install = true
  end
end
