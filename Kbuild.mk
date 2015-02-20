obj-${CONFIG_FOO} += foo/
obj-${CONFIG_BAR} += bar/
obj-${CONFIG_BAZ} += baz/

ifneq (${CONFIG_EXT_SVC_PATH},)
obj-y += ${CONFIG_EXT_SVC_PATH}/
endif
