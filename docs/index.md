# Setting up Raspberry Pi with Ansible

A set of helpful commands and tools to make setting up a Raspberry Pi a little easier.

This is the way _I_ prefer to setup an RPi, so your mileage may very.  That should not stop you from forking the code 
and doing your own thing.

## Setup
Following [Ansible best practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html), the project is structured 
with an inventories folder that contains the list of hosts that you will want to talk to.  There is a _work_ and a _home_ option that contains the 
names/ips and usernames of the host machines.  Also included are the various _children_ which relates to the stacks that contain the roles that you will implement the software and configuration that will be installed.

### Personalization
Additional directories can be added to inventories and setup similiar to home or work depending on how you want things to work or look.

## Commands
Everything should be driven through the _Makefile_.

* `make home` - Create a new project.
* `make work` - Start the live-reloading docs server.
* `make docs` - Build the docs and upload them to gh-pages.

## Project layout

    site.yml                # Main ansible playbook
    inventories/
        home/
            hosts.yml       # Inventory for home
            group_vars/
                all.yml     # various variables to be saved.
        work/
            hosts.yml       # Inventory for work
            group_vars/
                all.yml     # various variables to be saved.
    roles/
        common/             # applies to all hosts
        documentor/         # installs mkdocs
        julia/              # downloads and installs [Juila](https://julialang.org/)
        julia_compiler/     # installs the prerequisites to compile/build [Juila](https://julialang.org/)
        jupyter/            # installs a [JupyterHub](https://jupyterhub.readthedocs.io/en/stable/) instance