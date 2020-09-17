.PHONY: help

DATA_PATH := data

help:
	@echo "Please use 'make <target> [params]' where <target> is one of"
	@echo "  _install_pipfile       Install the pipfile"
	@echo "  notebook               Initilize jupyter notebook"
	@echo " "


_install_pipfile:
	pipenv --python 3.8.5 install -r requirements.txt


notebook:
	PIPENV_PIPFILE=Pipfile \
	pipenv run jupyter notebook