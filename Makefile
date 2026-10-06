ARCHS = arm64
TARGET = iphone:clang:16.5:16.0
INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TVProviderInfiniteLoading

TVProviderInfiniteLoading_FILES = Tweak.xm
TVProviderInfiniteLoading_CFLAGS = -fobjc-arc
TVProviderInfiniteLoading_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-clean::
	rm -rf packages .theos
