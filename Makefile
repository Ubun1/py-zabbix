PROJECT := pyzabbix
PACKAGE := python-$(PROJECT)
HEAD_SHA := $(shell git rev-parse --short HEAD)
BUILD_IMAGE_NAME := py-zabbix-build
MKFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

create-build-env: ; $(MKFILE_DIR)/buildah/build.sh $(BUILD_IMAGE_NAME)

rpm: ; podman run -v $(MKFILE_DIR)/RPMS:/root/rpmbuild/RPMS  --rm py-zabbix-build

spec: ; git cat-file -p $(HEAD_SHA):$(PACKAGE).spec | sed -e 's,@COMMIT@,$(HEAD_SHA),g' > $(PACKAGE).spec 

sources: spec 
	git archive --prefix=$(PACKAGE)-$(HEAD_SHA)/ --format=tar $(HEAD_SHA) | gzip > $(PACKAGE)-$(HEAD_SHA).tar.gz

clean: clean-build clean-pyc

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +
