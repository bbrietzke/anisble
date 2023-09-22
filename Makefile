.PHONY: work home docs test image

EXE := $(shell which ansible-playbook)
EXE_OPTIONS :=  						# make EXE_OPTIONS=--ask-become-pass updates
DOC := $(shell which mkdocs)			# make EXE_OPTIONS="--ask-become-pass --limit octopi"
UNAME_S := $(shell uname -s)
IMAGE_DIR := ./images
RASBIAN_IMAGE_NAME := 2021-03-04-raspios-buster-armhf-lite.img
UBUNTU_IMAGE_NAME := ubuntu-20.10-preinstalled-desktop-arm64+raspi.img
SLEEP_TIME := 10
TARGET_DISK := /dev/rdisk2

$(DOC):
	python3 -m pip install mkdocs

$(EXE):
	brew install ansible

docs: $(DOC)
	$(DOC) gh-deploy

update:
	$(EXE) $(EXE_OPTIONS) -i inventories/basement/hosts updates.yml

default:
	$(EXE) $(EXE_OPTIONS) -i inventories/basement/hosts default.yml

docker:
	$(EXE) $(EXE_OPTIONS) -i inventories/basement/hosts install_docker.yml

kube:
	$(EXE) $(EXE_OPTIONS) -i inventories/basement/hosts install_kubernetes.yml
	
reboot:
	$(EXE) $(EXE_OPTIONS) -i inventories/basement/hosts reboot.yml
	
shutdown:
	$(EXE) $(EXE_OPTIONS) -i inventories/basement/hosts shutdown.yml

support:
	$(EXE) $(EXE_OPTIONS) -i inventories/basement/hosts install_support_servers.yml

kubex:
	$(EXE) $(EXE_OPTIONS) -i inventories/basement/hosts install_kubernetes.yml

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

rasbian:
	@diskutil unmountDisk /dev/disk2 && \
	sudo dd bs=1m if=$(IMAGE_DIR)/$(RASBIAN_IMAGE_NAME) of=$(TARGET_DISK) && \
	sleep $(SLEEP_TIME) && \
	touch /Volumes/boot/ssh && \
	cp boot/wpa_supplicant.conf /Volumes/boot/  && \
	diskutil unmountDisk /dev/disk2 && \
	say "Disk has been formatted"

ubuntu:
	@diskutil unmountDisk /dev/disk2 && \
	sudo dd bs=1m if=$(IMAGE_DIR)/$(UBUNTU_IMAGE_NAME) of=$(TARGET_DISK) && \
	sleep $(SLEEP_TIME) && \
	cp boot/user-data /Volumes/system-boot/  && \
	cp boot/network-config /Volumes/system-boot/  && \
	say "Please enter the host name"  && \
	vi /Volumes/system-boot/user-data && \
	diskutil unmountDisk /dev/disk2


retropie:
	touch /Volumes/boot/ssh && \
	cp boot/wpa_supplicant.conf /Volumes/boot/  && \
	diskutil unmountDisk /dev/disk2
