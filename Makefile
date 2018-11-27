.PHONY docs

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

docs: $(DOC)
	mkdocs gh-deploy
	