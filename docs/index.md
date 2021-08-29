# Setting up Raspberry Pi with Ansible

A set of helpful commands and tools to make setting up a Raspberry Pi a little easier.

This is the way _I_ prefer to setup an RPi, so your mileage may very.  That should not stop you from forking the code
and doing your own thing.

## Building the SD Card

```
diskutil unmountDisk /dev/disk2 && \
sudo dd bs=1m if=~/Downloads/2020-02-13-raspbian-buster-lite.img of=/dev/rdisk2 && \
sleep 3 && \
touch /Volumes/boot/ssh && \
diskutil unmountDisk /dev/disk2
```

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

## Project layout

    boot/                   # saved files for copying to the boot images
    docs/                   # well, duh
    images/                 # where to save the img files from the RPF and Ubuntu
    inventories/
      home/
    home/
      inventory/      
        hosts               # all the machines in the network
        group_vars/         # variables to override different roles based on groupings
        host_vars/          # variables related to specific hosts
      project/
        default.yml         # default or site playbook
        updates.yml         # just doing updates and not much else
        roles/              # where the various roles live
          common/
          julia/
          jupyterhub/
          nginx/
          python/
          updates/

## Role Details
### julia
* Downloads the [Juila](https://julialang.org/) tar file and installs it to /opt
* creates a julia user for distributed work over ssh

### jupyterhub
* Install [Jupyter Hub](https://jupyterhub.readthedocs.io/en/stable/)
* Sets it up to run as a service

### nginx
* Vanillia NGinx install

### Python
* bring Python3 up to snuff
