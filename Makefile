ARCHS ?= arm64
include $(THEOS)/makefiles/common.mk

TOOL_NAME = extrainst_
extrainst__FILES = extrainst_.m
extrainst__INSTALL_PATH = /DEBIAN
extrainst__CODESIGN_FLAGS = -Sentitlements.xml
MERIDIAN_CC = xcrun -sdk iphoneos gcc -arch arm64
MERIDIAN_LDID = ldid2
DESTDIR = $(THEOS_OBJ_DIR)/ext

after-all::
	make -C MeridianJB/Meridian/pspawn_hook PREFIX=/usr/lib LDID="$(MERIDIAN_LDID)" CC="$(MERIDIAN_CC)" DESTDIR="$(DESTDIR)" install
	make -C libjailbreak PREFIX=/usr/lib LDID="$(MERIDIAN_LDID)" CC="$(MERIDIAN_CC)" DESTDIR="$(DESTDIR)" install
	make -C MeridianJB/Meridian/amfid PREFIX=/Library/MobileSubstrate/DynamicLibraries LDID="$(MERIDIAN_LDID)" CC="$(MERIDIAN_CC)" DESTDIR="$(DESTDIR)" install
	make -C MeridianJB/Meridian/unrestrict PREFIX=/Library/MobileSubstrate/ServerPlugins LDID="$(MERIDIAN_LDID)" CC="$(MERIDIAN_CC)" DESTDIR="$(DESTDIR)" install
	make -C MeridianJB/Meridian/jailbreakd PREFIX=/usr/libexec LDID="$(MERIDIAN_LDID)" CC="$(MERIDIAN_CC)" DESTDIR="$(DESTDIR)" install

after-stage::
	rsync -a $(THEOS_OBJ_DIR)/ext/. $(THEOS_STAGING_DIR)
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) \( -name \*.plist -or -name \*.strings \) -exec plutil -convert binary1 {} \;$(ECHO_END)
	$(ECHO_NOTHING)cd $(THEOS_STAGING_DIR); \
	find $(THEOS_STAGING_DIR) \( -path $(THEOS_STAGING_DIR)/DEBIAN -o -path $(THEOS_STAGING_DIR)/usr/share/undecimus/resources.txt \) -prune -o -type f -printf "%P\n" | xargs sha1sum > $(THEOS_STAGING_DIR)/usr/share/undecimus/resources.txt$(ECHO_END)

after-clean::
	make -C MeridianJB/Meridian/pspawn_hook clean
	make -C libjailbreak clean
	make -C MeridianJB/Meridian/amfid clean
	make -C MeridianJB/Meridian/unrestrict clean
	make -C MeridianJB/Meridian/jailbreakd clean

include $(THEOS_MAKE_PATH)/tool.mk
