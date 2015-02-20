obj-y += src/

ifneq (${CONFIG_EXT_SVC_PATH},)
obj-y += ${CONFIG_EXT_SVC_PATH}/
endif
