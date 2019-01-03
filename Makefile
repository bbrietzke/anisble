.PHONY: work home docs

EXE := /usr/local/bin/ansible-playbook
DOC := /usr/local/bin/mkdocs

$(DOC):
	pip install mkdocs

$(EXE):
	brew install ansible

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
