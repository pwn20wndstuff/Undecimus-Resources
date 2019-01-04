ARCHS ?= arm64
include $(THEOS)/makefiles/common.mk

TOOL_NAME = extrainst_ 
extrainst__FILES = extrainst_.m
extrainst__INSTALL_PATH = /DEBIAN
extrainst__CODESIGN_FLAGS = -Sentitlements.xml
extrainst__CFLAGS = -Wno-deprecated-declarations

DESTDIR = $(THEOS_OBJ_DIR)/ext

after-all::
	make -C unrestrict DESTDIR="$(DESTDIR)" install

after-stage::
	rsync -a $(THEOS_OBJ_DIR)/ext/. $(THEOS_STAGING_DIR)
	$(ECHO_NOTHING)cd $(THEOS_STAGING_DIR); \
	find $(THEOS_STAGING_DIR) \( -path $(THEOS_STAGING_DIR)/DEBIAN -o -path $(THEOS_STAGING_DIR)/usr/share/undecimus/resources.txt \) -prune -o -type f -printf "%P\n" | xargs sha1sum > $(THEOS_STAGING_DIR)/usr/share/undecimus/resources.txt$(ECHO_END)

after-clean::
	make -C unrestrict clean

include $(THEOS_MAKE_PATH)/tool.mk
