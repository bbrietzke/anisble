
EXE := /usr/local/bin/ansible-playbook

work:
	$(EXE) -i inventories/work/hosts.yml site.yml
