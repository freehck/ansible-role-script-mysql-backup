SHELL:=/bin/bash
export BRANCH=$(shell echo $(CI_BUILD_REF_NAME) | tr '[:upper:]' '[:lower:]')
export ROLE_NAME=ansible-role-mysql-backup
export STATIC_STORAGE_PATH=/var/www/file/public/$(ROLE_NAME)
export STATIC_STORAGE_HOST=file.dc47.com
export ROLE_TAR_ARCHIVE=$(ROLE_NAME).tgz

publish:
	tar czf $(ROLE_TAR_ARCHIVE) *
	ssh file@$(STATIC_STORAGE_HOST) install -d $(STATIC_STORAGE_PATH)/$(BRANCH)/$(CI_PIPELINE_ID)
	ssh file@$(STATIC_STORAGE_HOST) rm -f $(STATIC_STORAGE_PATH)/$(BRANCH)/latest
	ssh file@$(STATIC_STORAGE_HOST) ln -s $(STATIC_STORAGE_PATH)/$(BRANCH)/$(CI_PIPELINE_ID) $(STATIC_STORAGE_PATH)/$(BRANCH)/latest
	scp $(ROLE_TAR_ARCHIVE) file@$(STATIC_STORAGE_HOST):$(STATIC_STORAGE_PATH)/$(BRANCH)/$(CI_PIPELINE_ID)/
	@echo Link to role: https://$(STATIC_STORAGE_HOST)/$(ROLE_NAME)/$(BRANCH)/$(CI_PIPELINE_ID)/$(ROLE_TAR_ARCHIVE)
