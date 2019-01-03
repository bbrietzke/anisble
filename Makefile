.PHONY: work home docs

EXE := /usr/local/bin/ansible-playbook
DOC := /usr/local/bin/mkdocs
UNAME_S := $(shell uname -s)

$(DOC):
	pip install mkdocs

$(EXE):
	ifeq ($(UNAME_S),Linux)
		pip3 install -U ansible
	endif
	ifeq ($(UNAME_S),Darwin)
		brew install ansible
	endif

work: $(EXE)
	$(EXE) -i inventories/work/hosts.yml site.yml

home: $(EXE)
	$(EXE) -i inventories/home/hosts.yml site.yml

check_home: $(EXE)
	$(EXE) -i inventories/home/hosts.yml site.yml --check

check_work: $(EXE)
	$(EXE) -i inventories/work/hosts.yml site.yml --check

diff_home: $(EXE)
	$(EXE) -i inventories/home/hosts.yml site.yml --diff

diff_work: $(EXE)
	$(EXE) -i inventories/work/hosts.yml site.yml --diff

docs: $(DOC)
	$(DOC) gh-deploy
