# RancherOS Box

RancherOS. A simplified Linux distribution built from containers, for containers.

- RancherOS Vagrant Box
- Python included for Ansible
- Alpine as default console
- Bash as deafult shell
- without VirtualBox Guest Additions

The RancherOS Vagrant Box should be easy to keep up to date with new RancherOS releases. If you do not see the latest release on Vagrant Cloud, just build your own by following the steps below.

The default SSH Key has been set up for `vagrant ssh` to allow customizing via the the shell script provisioner.

## Install dependencies and Build environment

```shell
 dpkg -i https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_x86_64.deb

 wget https://releases.hashicorp.com/packer/1.5.4/packer_1.5.4_linux_amd64.zip
 unzip packer_1.5.4_linux_amd64.zip
 chmod +x packer
 mv packer /usr/local/bin

 vagrant --version && packer --version
Vagrant 2.2.7
1.5.4

```

## How to build (Bake with packer)

```shell
 git clone https://gitlab.com/walidsaad/rancheros-vagrantvbox-packer.git

 cd rancheros-vagrantvbox-packer
```

- Customize `RancherOS-common` with your Vagrant Cloud box name and token and adapt the RancherOS description as needed.
- Create a new box on Vagrant Cloud and choose the box name as set in `RancherOS-common`
- Possibly create a new file such as `RancherOS-1.4.0` with the latest version number and md5 hash based on info from:
  - [rancher/os releases](https://github.com/rancher/os/releases/)` iso-checksums.txt`
- Launch the build script with the applicable version number:
```
 ./build.sh 1.5.5
```

### Local test of the Box

```
 vagrant box add --name "RancherOS_1.5.5-local" RancherOS_1.5.5.box
 vagrant box list
RancherOS_1.5.5-local     (virtualbox, 0)
 mkdir -p test && cd test
 vagrant init RancherOS_1.3.0-local
 vagrant up
```

### Login to the Vagrant Cloud

```shell
vagrant login
In a moment we will ask for your username and password to HashiCorp's
Vagrant Cloud. After authenticating, we will store an access token locally on
disk. Your login details will be transmitted over a secure connection, and
are never stored on disk locally.

If you do not have an Vagrant Cloud account, sign up at
https://www.vagrantcloud.com

Vagrant Cloud username or email: walidsaad
Password (will be hidden): 
Token description (Defaults to "Vagrant login from walidos"): "set your token here"
You are now logged in.
```
### Publish the Box to the Vagrant Cloud

```shell
 vagrant cloud  publish  walidsaad/RancherOS_1.5.5 1.5.5 virtualbox --release RancherOS_1.5.5.box
You are about to publish a box on Vagrant Cloud with the following options:
walidsaad/RancherOS_1.5.5:   (v1.5.5) for provider 'virtualbox'
Do you wish to continue? [y/N] y
==> cloud: Creating a box entry...
==> cloud: Creating a version entry...
==> cloud: Creating a provider entry...
==> cloud: Uploading provider with file /home/walid/rancheros-box/RancherOS_1.5.5.box
Complete! Published walidsaad/RancherOS_1.5.5
tag:        walidsaad/RancherOS_1.5.5
username:   walidsaad
name:       RancherOS_1.5.5
private:    false
downloads:  0
created_at: 2020-03-13T00:57:57.297Z
updated_at: 2020-03-13T00:57:59.234Z
versions:   1.5.5

```

### Test the Box from the Vagrant Cloud

```shell
-Create the Vagrantfile
cat Vagrantfile 
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.box = "walidsaad/RancherOS_1.5.5"
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


-Create VirtualBox VM
vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'walidsaad/RancherOS_1.5.5'...
==> default: Matching MAC address for NAT networking...
==> default: Setting the name of the VM: test-rancheros-vagrant_default_1584093624696_84993
==> default: Vagrant has detected a configuration issue which exposes a
==> default: vulnerability with the installed version of VirtualBox. The
==> default: current guest is configured to use an E1000 NIC type for a
==> default: network adapter which is vulnerable in this version of VirtualBox.
==> default: Ensure the guest is trusted to use this configuration or update
==> default: the NIC type using one of the methods below:
==> default: 
==> default:   https://www.vagrantup.com/docs/virtualbox/configuration.html#default-nic-type
==> default:   https://www.vagrantup.com/docs/virtualbox/networking.html#virtualbox-nic-type
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: rancher
    default: SSH auth method: private key
    default: Warning: Remote connection disconnect. Retrying...
    default: Warning: Connection reset. Retrying...
    default: Warning: Remote connection disconnect. Retrying...
    default: Warning: Connection reset. Retrying...
    default: 
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default: 
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!


-ssh to VM
vagrant ssh
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <http://wiki.alpinelinux.org/>.

You can setup the system with the command: setup-alpine

You may change this message by editing /etc/motd.

rancher:~$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
rancher:~$
