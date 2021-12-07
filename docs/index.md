# Setting up Raspberry Pi with Ansible

A set of helpful commands and tools to make setting up a Raspberry Pi a little easier.

## Setup
Following [Ansible best practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html), the project is structured
with an inventories folder that contains the list of hosts that you will want to talk to.  There is a _work_ and a _home_ option that contains the
names/ips and usernames of the host machines.  Also included are the various _children_ which relates to the groups that contain the roles that you will implement the software and configuration that will be installed.

The bootable images should be saved in the 'image' directory.  Make sure you updated the image names in the Makefile so the 'image' creation commands work.

### Personalization
Additional directories can be added to inventories and setup similiar to home or work depending on how you want things to work or look.

## Commands
Everything should be driven through the _Makefile_.

* `make home` - Create a new project.
* `make rasbian` - create the rasbian image.
* `make ubuntu` - create the ubuntu image.
* `make docs` - Build the docs and upload them to gh-pages.
* `make reboot` - reboot all the Raspberry Pi's
* `make docker` - Install the docker role
* `make kube` - Install Kubernetes
* `make volumes` - Build NFS volumes
* `make buildServers` - Install Jenkins CI/CD
* `make docker` - Install docker
* `make reboot` - REBOOT!

## Playbook Details
### Kube
* Installs kubernetes and docker on target machines; install an NFS server on a seperate machine for persistent volumes.

### Docker
* Installs Docker from the docker repositories.

### Jenkins
* Installs jenkins, an NFS client and docker; mounts an NFS drive from the designated server

### Updates
* Updates the computers based on model type; only does two at a time

### Reboot
* Well, it reboots the machines

