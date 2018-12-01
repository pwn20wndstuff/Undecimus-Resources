ARCHS ?= arm64
include $(THEOS)/makefiles/common.mk

TOOL_NAME = extrainst_
extrainst__FILES = extrainst_.m
extrainst__INSTALL_PATH = /DEBIAN
extrainst__CODESIGN_FLAGS = -Sentitlements.xml

after-stage::
	$(ECHO_NOTHING)cd "$(THEOS_STAGING_DIR)"; \
	find . -type f | grep -v '^./DEBIAN' | grep -v resources.txt | xargs sha1sum > usr/share/undecimus/resources.txt$(ECHO_END)

include $(THEOS_MAKE_PATH)/tool.mk
