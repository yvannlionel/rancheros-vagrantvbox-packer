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

```
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
mkdir -p test && cd test
vagrant init RancherOS_1.3.0-local
vagrant up
```
### Publish the Box to the Vagrant Cloud

```shell
vagrant login
vagrant cloud  publish  walidsaad/RancherOS_1.5.5 1.5.5 virtualbox RancherOS_1.5.5.box
```
