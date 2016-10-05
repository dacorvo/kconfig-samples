# Override default output directory with OUT=/path/to/output on the command line
OUT ?= output

# Create output dir
OUT := $(shell mkdir -p $(OUT) && cd $(OUT) > /dev/null && pwd)

# By default, define external services Kconfig file as our dummy
EXTERNAL_SERVICES ?= external/none

# The root Kconfig file
KCONFIG := Kconfig

# The mconf tool used to perform the "menuconfig" step
KCONFIG_MCONF := $(shell which mconf)

# The conf tool used to perform the "config" step
KCONFIG_CONF := $(shell which conf)

# The Kconfig output files directory
KCONFIG_DIR := \
	$(shell mkdir -p $(OUT)/config \
	&& cd $(OUT)/config > /dev/null \
	&& pwd)

# Kconfig "menuconfig" output file
KCONFIG_CONFIG := $(KCONFIG_DIR)/.config

# Kconfig "config" output files
KCONFIG_AUTOCONFIG := $(KCONFIG_DIR)/auto.conf
KCONFIG_AUTOHEADER := $(KCONFIG_DIR)/autoconf.h
KCONFIG_TRISTATE := $(KCONFIG_DIR)/tristate.config

# Kconfig "defconfig" output file
KCONFIG_DEFCONFIG := $(KCONFIG_DIR)/defconfig

# The environment to export before running Kconfig tools,
# allowing to control their output
KCONFIG_ENV := \
	KCONFIG_CONFIG=$(KCONFIG_CONFIG) \
	KCONFIG_AUTOCONFIG=$(KCONFIG_AUTOCONFIG) \
	KCONFIG_AUTOHEADER=$(KCONFIG_AUTOHEADER) \
	KCONFIG_TRISTATE=$(KCONFIG_TRISTATE) \
	EXTERNAL_SERVICES=$(EXTERNAL_SERVICES)

# We have to reference the 'all' rule to make it the default
all:

# Generic rules
all: build
	@echo "Done"

clean:
	rm -rf $(OUT)

menuconfig:
ifdef KCONFIG_MCONF
	$(KCONFIG_ENV) $(KCONFIG_MCONF) $(KCONFIG)
else
	@echo "The menuconfig target requires Kconfig's mconf"
endif

config: $(KCONFIG_CONFIG)
ifdef KCONFIG_CONF
	@echo "Producing configuration files for build"
	@install -d include/config
	$(KCONFIG_ENV) $(KCONFIG_CONF) --silentoldconfig $(KCONFIG)
	@rm -rf include/config
else
	@echo "The config target requires Kconfig's conf"
endif

savedefconfig: $(KCONFIG_CONFIG)
	@echo "Creating the minimal configuration"
	$(KCONFIG_ENV) $(KCONFIG_CONF) --savedefconfig defconfig $(KCONFIG)

build: $(KCONFIG_AUTOCONFIG) $(KCONFIG_AUTOHEADER) $(KCONFIG_TRISTATE)
	$(MAKE) -f Makefile.build 	\
		SRC=.					\
		OUT=$(OUT)				\
		AUTOCONFIG=$(KCONFIG_AUTOCONFIG) \
		INC_ROOT=$(CURDIR)/include
