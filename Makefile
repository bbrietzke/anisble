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

updates:
	$(EXE) $(EXE_OPTIONS) -i inventories/home/hosts updates.yml

default:
	$(EXE) $(EXE_OPTIONS) -i inventories/home/hosts default.yml

docker:
	$(EXE) $(EXE_OPTIONS) -i inventories/home/hosts install_docker.yml

iscsi:
	$(EXE) $(EXE_OPTIONS) -i inventories/home/hosts install_iscsi.yml

kube:  # sudo sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1/' /boot/firmware/cmdline.txt
	$(EXE) $(EXE_OPTIONS) -i inventories/home/hosts install_kubernetes.yml
	
reboot:
	$(EXE) $(EXE_OPTIONS) -i inventories/home/hosts reboot.yml

docs: $(DOC)
	$(DOC) gh-deploy

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

imager:
	cp boot/user-data /Volumes/system-boot/user-data
	vi /Volumes/system-boot/user-data