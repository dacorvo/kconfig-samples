# Override default output directory with O=/path/to/output on the command line
O ?= output

# Create output dir
BUILD_DIR := $(shell mkdir -p $(O) && cd $(O) > /dev/null && pwd)

# The root Kconfig file
KCONFIG := Kconfig

# The mconf tool used to perform the "menuconfig" step
KCONFIG_MCONF := $(shell which mconf)

# The conf tool used to perform the "config" step
KCONFIG_CONF := $(shell which conf)

# The Kconfig output files directory
KCONFIG_DIR := \
	$(shell mkdir -p $(BUILD_DIR)/config \
	&& cd $(BUILD_DIR)/config > /dev/null \
	&& pwd)

# Kconfig "menuconfig" output file
KCONFIG_CONFIG := $(KCONFIG_DIR)/.config

# Kconfig "config" output files
KCONFIG_AUTOCONFIG := $(KCONFIG_DIR)/auto.conf
KCONFIG_AUTOHEADER := $(KCONFIG_DIR)/autoconf.h
KCONFIG_TRISTATE := $(KCONFIG_DIR)/tristate.config

# The environment to export before running Kconfig tools,
# allowing to control their output
KCONFIG_ENV := \
	KCONFIG_CONFIG=$(KCONFIG_CONFIG) \
	KCONFIG_AUTOCONFIG=$(KCONFIG_AUTOCONFIG) \
	KCONFIG_AUTOHEADER=$(KCONFIG_AUTOHEADER) \
	KCONFIG_TRISTATE=$(KCONFIG_TRISTATE)

# A minimal module template, to be evaluated from module makefiles
# Takes the module name as the first parameter
define MODULE_template
ifeq ($(CONFIG_$(2)),y)
MODULES += $(1)
$(1): $(BUILD_DIR)/$(1)/.built
$(BUILD_DIR)/$(1)/.built:
	@echo "Building $(1)"
	@mkdir -p $(BUILD_DIR)/$(1)
	@touch $(BUILD_DIR)/$(1)/.built
endif
endef

# We have to reference the 'all' rule to make it the default
all:

# Include the project configuration file
-include $(KCONFIG_CONFIG)

# Include all module makefiles
include ./*/*.mk

# Generic rules
all: $(MODULES)
	@echo "Done"

clean:
	rm -rf $(BUILD_DIR)

menuconfig:
ifdef KCONFIG_MCONF
	$(KCONFIG_ENV) $(KCONFIG_MCONF) $(KCONFIG)
else
	@echo "The menuconfig target requires Kconfig's mconf"
endif

config: $(KCONFIG_CONFIG)
ifdef KCONFIG_CONF
	@install -d include/config
	$(KCONFIG_ENV) $(KCONFIG_CONF) --silentoldconfig $(KCONFIG)
	@mv include/config/* $(KCONFIG_DIR)
	@rm -rf include
else
	@echo "The config target requires Kconfig's conf"
endif
