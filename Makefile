ARCHS ?= arm64
include $(THEOS)/makefiles/common.mk

TOOL_NAME = extrainst_
extrainst__FILES = extrainst_.m
extrainst__INSTALL_PATH = /DEBIAN
extrainst__CODESIGN_FLAGS = -Sentitlements.xml

after-stage::
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) \( -name \*.plist -or -name \*.strings \) -exec plutil -convert binary1 {} \;$(ECHO_END)
	$(ECHO_NOTHING)cd $(THEOS_STAGING_DIR); \
	find $(THEOS_STAGING_DIR) \( -path $(THEOS_STAGING_DIR)/DEBIAN -o -path $(THEOS_STAGING_DIR)/usr/share/undecimus/resources.txt \) -prune -o -type f -printf "%P\n" | xargs sha1sum > $(THEOS_STAGING_DIR)/usr/share/undecimus/resources.txt$(ECHO_END)

include $(THEOS_MAKE_PATH)/tool.mk
