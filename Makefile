.PHONY: work home docs test image

EXE := /usr/local/bin/ansible-playbook
DOC := /usr/local/bin/mkdocs
UNAME_S := $(shell uname -s)
IMAGE_DIR := ./images
RASBIAN_IMAGE_NAME := 2021-03-04-raspios-buster-armhf-lite.img
UBUNTU_IMAGE_NAME := ubuntu-20.10-preinstalled-desktop-arm64+raspi.img
SLEEP_TIME := 10
TARGET_DISK := /dev/rdisk2

$(DOC):
	pip3 install mkdocs

$(EXE):
	brew install ansible

default:
	$(EXE) -i home/inventory/hosts home/project/default.yml

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
	vi /Volumes/system-boot/user-data && \
	diskutil unmountDisk /dev/disk2 && \
	say "Disk has been formatted"
