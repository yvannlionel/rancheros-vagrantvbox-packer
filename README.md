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
 vagrant cloud  publish  walidsaad/RancherOS_1.5.5 1.5.5 virtualbox RancherOS_1.5.5.box
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


