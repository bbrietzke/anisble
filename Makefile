
EXE := /usr/local/bin/ansible

work:
	$(EXE) -i inventories/work/hosts.yml site.yml
