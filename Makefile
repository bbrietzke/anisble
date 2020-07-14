.PHONY: work home docs test image

EXE := /usr/local/bin/ansible-playbook
DOC := /usr/local/bin/mkdocs
UNAME_S := $(shell uname -s)
IMAGE_DIR := ./images
RASBIAN_IMAGE_NAME := 2020-05-27-raspios-buster-lite-armhf.img
UBUNTU_IMAGE_NAME := ubuntu-20.04-preinstalled-server-arm64+raspi.img

$(DOC):
	pip install mkdocs

$(EXE):
	brew install ansible

raspberry: $(EXE)
	ssh-copy-id pi@raspberrypi.local
	$(EXE) -i inventories/pi/hosts.yml site.yml

zero: $(EXE)
	$(EXE) -i inventories/zero/hosts.yml site.yml

work: $(EXE)
	$(EXE) -i inventories/work/hosts.yml site.yml

home: $(EXE)
	$(EXE) -i inventories/home/hosts.yml site.yml

swarm: $(EXE)
	$(EXE) -i inventories/swarm/hosts.yml site.yml

test: $(EXE)
	$(EXE) --list-tasks -i inventories/work/hosts.yml site.yml
	$(EXE) --syntax-check -i inventories/work/hosts.yml site.yml
	$(EXE) --list-tasks -i inventories/home/hosts.yml site.yml
	$(EXE) --syntax-check -i inventories/home/hosts.yml site.yml
	$(EXE) --list-tasks -i inventories/zero/hosts.yml site.yml
	$(EXE) --syntax-check -i inventories/zero/hosts.yml site.yml

docs: $(DOC)
	$(DOC) gh-deploy

rasbian:
	@diskutil unmountDisk /dev/disk2 && \
	sudo dd bs=1m if=$(IMAGE_DIR)/$(RASBIAN_IMAGE_NAME) of=/dev/rdisk2 && \
	sleep 9 && \
	touch /Volumes/boot/ssh && \
	cp boot/wpa_supplicant.conf /Volumes/boot/  && \
	diskutil unmountDisk /dev/disk2

ubuntu:
	@diskutil unmountDisk /dev/disk2 && \
	sudo dd bs=1m if=$(IMAGE_DIR)/$(UBUNTU_IMAGE_NAME) of=/dev/rdisk2 && \
	sleep 9 && \
	cp boot/user-data /Volumes/system-boot/  && \
	cp boot/network-config /Volumes/system-boot/  && \
	vi /Volumes/system-boot/user-data && \
	diskutil unmountDisk /dev/disk2
