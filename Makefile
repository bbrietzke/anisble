.PHONY: work home docs test image

EXE := $(shell which ansible-playbook)
EXE_OPTIONS :=  						# make EXE_OPTIONS=--ask-become-pass updates
DOC := $(shell which mkdocs)			# make EXE_OPTIONS="--ask-become-pass --limit octopi"
UNAME_S := $(shell uname -s)
DEFAULT_GROUP := apartment

$(DOC):
	python3 -m pip install mkdocs

$(EXE):
	brew install ansible

docs: $(DOC)
	$(DOC) gh-deploy

openstack: 
	$(EXE) $(EXE_OPTIONS) -i inventories/$(DEFAULT_GROUP)/hosts openstack.yml

update:
	$(EXE) $(EXE_OPTIONS) -i inventories/$(DEFAULT_GROUP)/hosts updates.yml

default:
	$(EXE) $(EXE_OPTIONS) -i inventories/$(DEFAULT_GROUP)/hosts default.yml
	
reboot:
	$(EXE) $(EXE_OPTIONS) -i inventories/$(DEFAULT_GROUP)/hosts reboot.yml
	
shutdown:
	$(EXE) $(EXE_OPTIONS) -i inventories/$(DEFAULT_GROUP)/hosts shutdown.yml

whatever:
	cp boot/user-data/user-data.rpi /Volumes/system-boot/user-data
	touch /Volumes/system-boot/meta-data
	touch /Volumes/system-boot/ssh
	diskutil eject /Volumes/system-boot

wifi:
	cp boot/network-config /Volumes/system-boot/network-config

octopi:
	cp boot/wpa_supplicant.conf /Volumes/boot/
	cp boot/octopi.txt /Volumes/boot/octopi.txt
	touch /Volumes/boot/ssh

retropie:
	touch /Volumes/boot/ssh && \
	cp boot/wpa_supplicant.conf /Volumes/boot/  && \
	diskutil unmountDisk /dev/disk2







# sudo kubeadm init --control-plane-endpoint=pandora --pod-network-cidr=192.168.0.0/16

# kubeadm join pandora:6443 --token ehpx0v.bh4z146391qfbhim --discovery-token-ca-cert-hash sha256:912983c080fad53470ce8b833e770181cf6f87b6509763732fb8e34feebd4690