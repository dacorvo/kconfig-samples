# Override default output directory with O=/path/to/output on the command line
O ?= output

# Create output dir
BUILD_DIR := $(shell mkdir -p $(O) && cd $(O) > /dev/null && pwd)

# The root Kconfig file
KCONFIG := Kconfig

# The mconf tool used to generate the project configuration
KCONFIG_MCONF := $(shell which mconf)

# The resulting configuration file
CONFIG := .config

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
-include $(CONFIG)

# Include all module makefiles
include ./*/*.mk

# Generic rules
all: $(MODULES)
	@echo "Done"

clean:
	rm -rf $(BUILD_DIR)

menuconfig:
ifdef KCONFIG_MCONF
	$(KCONFIG_MCONF) $(KCONFIG)
else
	@echo "The menuconfig target requires Kconfig's mconf"
endif
