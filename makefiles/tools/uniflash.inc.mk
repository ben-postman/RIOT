# http://www.ti.com/tool/uniflash
FLASHFILE ?= $(ELFFILE)

export UNIFLASH_PATH ?= "UNIFLASH_PATH unconfigured"
# check which uniflash version is available, either 4.x or 3.x
ifneq ("$(wildcard $(UNIFLASH_PATH)/dslite.sh)","")
  FLASHER ?= $(UNIFLASH_PATH)/dslite.sh
  FFLAGS  = --config $(RIOTBOARD)/$(BOARD)/dist/$(CPU_MODEL)_$(XDEBUGGER).ccxml $(FLASHFILE)
  # configure uniflash for resetting target
  # xds110reset path changed in version UniFlash v4.4.0
  # Try to detect the newest one and fallback to only 'xds110reset'
  _XDS110RESET_4_0_4_3 ?= $(UNIFLASH_PATH)/simplelink/gen2/bin/xds110reset
  _XDS110RESET ?= $(UNIFLASH_PATH)/simplelink/imagecreator/bin/xds110reset
  XDS110RESET ?= $(firstword $(wildcard $(_XDS110RESET) $(_XDS110RESET_4_0_4_3)) xds110reset)
  RESET = $(XDS110RESET)
  RESET_FLAGS
else
  FLASHER = $(UNIFLASH_PATH)/uniflash.sh
  FFLAGS  = -ccxml $(RIOTBOARD)/$(BOARD)/dist/$(CPU_MODEL)_$(XDEBUGGER).ccxml -program $(FLASHFILE)
  # configure uniflash for resetting target
  RESET = $(UNIFLASH_PATH)/uniflash.sh
  RESET_FLAGS = -ccxml $(RIOTBOARD)/$(BOARD)/dist/$(CPU_MODEL)_$(XDEBUGGER).ccxml -reset
endif
# configure the debug server
DEBUGSERVER = $(UNIFLASH_PATH)/ccs_base/common/uscif/gdb_agent_console
DEBUGSERVER_FLAGS = -p 3333 $(RIOTBOARD)/$(BOARD)/dist/$(CPU_MODEL)_$(XDEBUGGER).dat

# configure the debugging tool
DEBUGGER = $(PREFIX)gdb
DEBUGGER_FLAGS = -x $(RIOTBOARD)/$(BOARD)/dist/$(CPU_MODEL)_gdb.conf $(ELFFILE)
