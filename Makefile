# Override default output directory with O=/path/to/output on the command line
O ?= output

# Create output dir
BUILD_DIR := $(shell mkdir -p $(O) && cd $(O) > /dev/null && pwd)

# A minimal module template, to be evaluated from module makefiles
# Takes the module name as the first parameter
define MODULE_template
MODULES += $(1)
$(1): $(BUILD_DIR)/$(1)/.built
$(BUILD_DIR)/$(1)/.built:
	@echo "Building $(1)"
	@mkdir -p $(BUILD_DIR)/$(1)
	@touch $(BUILD_DIR)/$(1)/.built
endef

# We have to reference the 'all' rule to make it the default
all:

# Include all module makefiles
include ./*/*.mk

# Generic rules
all: $(MODULES)
	@echo "Done"

clean:
	rm -rf $(BUILD_DIR)
