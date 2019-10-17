.PHONY: work home docs test image

EXE := /usr/local/bin/ansible-playbook
DOC := /usr/local/bin/mkdocs
UNAME_S := $(shell uname -s)
IMAGE_NAME := 2019-09-26-raspbian-buster-lite.img

$(DOC):
	pip install mkdocs

$(EXE):
	brew install ansible

work: $(EXE)
	$(EXE) -i inventories/work/hosts.yml site.yml

home: $(EXE)
	$(EXE) -i inventories/home/hosts.yml site.yml

test: $(EXE)
	$(EXE) --list-tasks -i inventories/work/hosts.yml site.yml
	$(EXE) --syntax-check -i inventories/work/hosts.yml site.yml
	$(EXE) --list-tasks -i inventories/home/hosts.yml site.yml
	$(EXE) --syntax-check -i inventories/home/hosts.yml site.yml

docs: $(DOC)
	$(DOC) gh-deploy

image: 
	@diskutil unmountDisk /dev/disk2 && \
	sudo dd bs=1m if=$(HOME)/Downloads/$(IMAGE_NAME) of=/dev/rdisk2 && \
	sleep 3 && \
	touch /Volumes/boot/ssh && \
	diskutil unmountDisk /dev/disk2