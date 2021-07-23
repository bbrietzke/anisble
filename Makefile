.PHONY: work home docs test image

EXE := $(shell which ansible-playbook)
DOC := $(shell which mkdocs)
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
	$(EXE) -i inventories/home/hosts updates.yml

default:
	$(EXE) -i inventories/home/hosts default.yml

docker:
	$(EXE) -i inventories/home/hosts install_docker.yml

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
	cp boot/user-data boot/user-data/user-data.old
	cp boot/user-data /Volumes/system-boot/user-data
	vi /Volumes/system-boot/user-data