#######################################################################################################################
# Module configuration

libnetconf_PROJECT_ROOT = $(PROJECT_ROOT)/clientapi

libnetconf_header_install_dir = $(DESTDIR)/usr/include/netconf

libnetconf_install_headers = $(call fglob_r,$(libnetconf_PROJECT_ROOT)/extern, h hpp)
libnetconf_header_install_targets = $(addprefix $(libnetconf_header_install_dir)/, $(notdir $(libnetconf_install_headers)))

#######################################################################################################################
# Build target configuration

INCLUDES += \
$(libnetconf.a_INCLUDES)

MAIN_BUILDTARGETS += \
libnetconf.a

TEST_BUILDTARGETS += \
libnetconf_tests.elf

INSTALL_TARGETS += \
$(libnetconf_header_install_targets) \
$(DESTDIR)/usr/lib/libnetconf.a \
$(DESTDIR)/usr/lib/pkgconfig/libnetconf.pc


#######################################################################################################################
# Settings for build target libnetconf.a

libnetconf.a_INCLUDES += \
-I$(PROJECT_ROOT)/extern/ \
-I$(libnetconf_PROJECT_ROOT)/extern/


libnetconf.a_DISABLEDWARNINGS +=
libnetconf.a_CXXDISABLEDWARNINGS += $(libnetconf.a_DISABLEDWARNINGS) abi-tag
libnetconf.a_CDISABLEDWARNINGS += $(libnetconf.a_DISABLEDWARNINGS)
libnetconf.a_DEFINES +=
libnetconf.a_LIBS += boost_system boost_filesystem
libnetconf.a_PKG_CONFIGS = dbus-1
libnetconf.a_CPPFLAGS += $(call uniq, $(libnetconf.a_INCLUDES) $(libbridge.a_INCLUDES))
libnetconf.a_CPPFLAGS += $(call uniq, $(libbridge.a_DEFINES))
libnetconf.a_CPPFLAGS += $(call pkg_config_cppflags,$(libnetconf.a_PKG_CONFIGS))
libnetconf.a_CCXXFLAGS += $(OPTION_HIDE_SYMBOLS)
libnetconf.a_CCXXFLAGS += $(OPTION_PIC)
libnetconf.a_CFLAGS += $(call pkg_config_cflags,$(libnetconf.a_PKG_CONFIGS))
libnetconf.a_CFLAGS += $(call option_std,c99)
libnetconf.a_CFLAGS += $(call option_disable_warning,$(libnetconf.a_CDISABLEDWARNINGS))
libnetconf.a_CFLAGS += $(libnetconf.a_CCXXFLAGS)
libnetconf.a_CXXFLAGS += $(call pkg_config_cxxflags,$(libnetconf.a_PKG_CONFIGS))
libnetconf.a_CXXFLAGS += $(call option_std,c++14)
libnetconf.a_CXXFLAGS += $(call option_disable_warning,$(libnetconf.a_CXXDISABLEDWARNINGS))
libnetconf.a_CXXFLAGS += $(libnetconf.a_CCXXFLAGS)
libnetconf.a_SOURCES += $(call fglob_r,$(libnetconf_PROJECT_ROOT)/src,$(SOURCE_FILE_EXTENSIONS))
libnetconf.a_CLANG_TIDY_RULESET = $(CLANG_TIDY_CHECKS)
libnetconf.a_CLANG_TIDY_CHECKS += -clang-diagnostic-c++98-c++11-compat
libnetconf.a_CLANG_TIDY_CHECKS += -google-runtime-references




#######################################################################################################################
# Settings for build target libnetconf_tests.elf

libnetconf_tests.elf_INCLUDES = \
$(libnetconf.a_INCLUDES) \
-I$(PROJECT_ROOT)/clientapi/extern \
-I$(libnetconf_PROJECT_ROOT)/test-extern/ \
-I$(libnetconf_PROJECT_ROOT)/src/ \


libnetconf_tests.elf_STATICALLYLINKED += netconf gmock_main gmock gtest
libnetconf_tests.elf_LIBS += netconf gmock_main gmock gtest $(libnetconf.a_LIBS)
libnetconf_tests.elf_PKG_CONFIGS += $(libnetconf.a_PKG_CONFIGS)
libnetconf_tests.elf_PKG_CONFIG_LIBS += $(libnetconf.a_PKG_CONFIG_LIBS)
libnetconf_tests.elf_DISABLEDWARNINGS += packed
libnetconf_tests.elf_CDISABLEDWARNINGS += $(libnetconf_tests.elf_DISABLEDWARNINGS)
libnetconf_tests.elf_CXXDISABLEDWARNINGS += $(libnetconf_tests.elf_DISABLEDWARNINGS) useless-cast suggest-override abi-tag
libnetconf_tests.elf_PREREQUISITES += $(call lib_buildtarget_raw,$(libnetconf_tests.elf_LIBS) $(libnetconf_tests.elf_PKG_CONFIG_LIBS),$(libnetconf_tests.elf_STATICALLYLINKED))
libnetconf_tests.elf_CPPFLAGS += $(call uniq, $(libnetconf_tests.elf_INCLUDES))
libnetconf_tests.elf_CPPFLAGS += $(call uniq, $(libnetconf.a_DEFINES))
libnetconf_tests.elf_CPPFLAGS += $(call pkg_config_cppflags,$(libnetconf_tests.elf_PKG_CONFIGS))
libnetconf_tests.elf_CFLAGS += $(call option_std,gnu99)
libnetconf_tests.elf_CFLAGS += $(call option_disable_warning,$(libnetconf_tests.elf_CDISABLEDWARNINGS))
libnetconf_tests.elf_CXXFLAGS += $(call option_std,gnu++14)
libnetconf_tests.elf_CXXFLAGS += $(call option_disable_warning,$(libnetconf_tests.elf_CXXDISABLEDWARNINGS))
libnetconf_tests.elf_LDFLAGS += $(call option_lib,$(libnetconf_tests.elf_LIBS),libnetconf_tests.elf)
libnetconf_tests.elf_LDFLAGS += $(call pkg_config_ldflags,$(libnetconf_tests.elf_PKG_CONFIGS))
libnetconf_tests.elf_SOURCES += $(call fglob_r,$(libnetconf_PROJECT_ROOT)/test-src,$(SOURCE_FILE_EXTENSIONS))
libnetconf_tests.elf_DISABLE_CLANG_TIDY = T
libnetconf_tests.elf_CLANG_TIDY_CHECKS += -clang-diagnostic-c++98-c++11-compat
libnetconf_tests.elf_CLANG_TIDY_CHECKS += -google-runtime-references
#######################################################################################################################
# Custom install rules

$(libnetconf_header_install_dir)/% : $(libnetconf_PROJECT_ROOT)/extern/%
	mkdir -p $(dir $@) && cp $(realpath $<) $@

# Package config file
$(DESTDIR)/usr/lib/pkgconfig/%.pc: $(libnetconf_PROJECT_ROOT)/%.pc | $(DESTDIR)/usr/lib/pkgconfig
	cp $< $@
