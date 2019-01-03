.PHONY: work home docs

EXE := /usr/local/bin/ansible-playbook
DOC := /usr/local/bin/mkdocs
UNAME_S := $(shell uname -s)

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

docs: $(DOC)
	$(DOC) gh-deploy
