# for all
TOPNAME		=	TOP
TOP_DIR		:=	$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
BUILD_PATH	=	$(TOP_DIR)build

.PHONY: test verilog help compile bsp reformat checkformat clean

# verilator
VAL				=	verilator
VAL_DIR			=	$(TOP_DIR)$(VAL)
VAL_CFLAGS		+=	-MMD --build -cc -O3 --x-assign fast --x-initial fast --noassert
CFLAGS			+=	-DTOP_NAME=V$(TOPNAME)
VAL_INC_PATH	=	$(VAL_DIR)/INC
VAL_SRC_PATH	=	$(VAL_DIR)/SRC
VAL_SRC_DIR		=	$(foreach dir,$(VAL_SRC_PATH),$(wildcard $(dir)/*.cpp))
VAL_BUILD_PATH	=	$(BUILD_PATH)/$(VAL)
VAL_OBJ_PATH	=	$(VAL_BUILD_PATH)/temp
VAL_BIN_PATH	=	$(VAL_BUILD_PATH)/bin
VAL_BIN			=	$(VAL_BIN_PATH)/$(TOPNAME)
VAL_WAVE_DIR	=	$(VAL_BIN_PATH)/wave.vcd

# nvboard
include $(NVBOARD_HOME)/scripts/nvboard.mk
NV					=	nvboard
NV_DIR				=	$(TOP_DIR)$(NV)
NV_VERILATOR_CFLAGS	+=	-MMD --build -cc -O3 --x-assign fast --x-initial fast --noassert
NV_BUILD_PATH		=	$(BUILD_PATH)/$(NV)
NV_OBJ_PATH			=	$(NV_BUILD_PATH)/temp
NV_BIN_PATH			=	$(NV_BUILD_PATH)/bin
NV_CPP_INC_PATH		=	$(NV_DIR)/INC
NV_CPP_INC_PATH		+=	$(INC_PATH)
NV_CPP_SRC_PATH		=	$(NV_DIR)/SRC
NV_CPP_SRC_DIR		=	$(foreach dir,$(NV_CPP_SRC_PATH),$(wildcard $(dir)/*.cpp))
NV_BIN				=	$(NV_BIN_PATH)/$(TOPNAME)
NV_CONSTR			=	$(NV_DIR)/constr
NV_NXDC				=	$(wildcard $(NV_CONSTR)/*.nxdc)
NV_SRC_AUTO_BIND	=	$(NV_OBJ_PATH)/auto_bind.cpp
NV_INCFLAGS			=	$(addprefix -I,$(NV_CPP_INC_PATH))
NV_CFLAGS			=	$(NV_INCFLAGS) -DTOP_NAME=V$(TOPNAME)
NV_LDFLAGS			+=	-lSDL2 -lSDL2_image

# chisel
CHISEL_BUILD_PATH 	= 	$(BUILD_PATH)/chisel
CHISEL_BUILD_VSRC 	= 	$(CHISEL_BUILD_PATH)/$(TOPNAME).v
CHISEL_TEST_DIR 	= 	$(TOP_DIR)/test_run_dir	
export PATH 		:= 	$(PATH):$(abspath ./utils)

# verilator
val: build_prepare $(VAL_BIN)

$(VAL_WAVE_DIR): $(VAL_BIN)
	@cd $(VAL_BIN_PATH) && ./$(TOPNAME)

valrun: $(VAL_WAVE_DIR) build_prepare
	@echo "> RUN $(VAL_BIN_PATH)/$(TOPNAME)"

valsim: $(VAL_WAVE_DIR) val_run
	@echo "> SIM $<"
	@gtkwave $< 

$(VAL_BIN): $(CHISEL_BUILD_VSRC) $(VAL_SRC_DIR)
	@rm -rf $(VAL_OBJ_PATH)
	@echo "+ V\t$(CHISEL_BUILD_VSRC)"
	$(foreach vfile, $(CHISEL_BUILD_VSRC), $(info + V $(vfile)))
	$(foreach cppfile, $(VAL_SRC_DIR), $(info + CPP$(TAB)$(cppfile)))
	$(VAL) $(VAL_CFLAGS) \
	--top-module $(TOPNAME) \
	$^ $(addprefix -I,$(VAL_INC_PATH)) $(CFLAGS) \
	--Mdir $(VAL_OBJ_PATH) --trace --exe \
	-o $(VAL_BIN)

# nvboard
nv: build_prepare $(NV_BIN)

nvrun: $(NV_BIN) build_prepare
	@echo "> RUN $<"
	@$<

$(NV_BIN): $(CHISEL_BUILD_VSRC) $(NV_CPP_SRC_DIR) $(NVBOARD_ARCHIVE) $(NV_SRC_AUTO_BIND)
	@rm -rf $(NV_OBJ_PATH)/V*
	$(foreach vfile, $(CHISEL_BUILD_VSRC), $(info + V$(TAB)$(vfile)))
	$(foreach cppfile, $(NV_CPP_SRC_DIR), $(info + CPP$(TAB)$(cppfile)))
	$(VAL) $(NV_VERILATOR_CFLAGS) \
	--top-module $(TOPNAME) \
	$^ $(addprefix -CFLAGS , $(NV_CFLAGS)) $(addprefix -LDFLAGS , $(NV_LDFLAGS)) \
	--Mdir $(NV_OBJ_PATH) --trace --exe \
	-o $(NV_BIN)

$(NV_SRC_AUTO_BIND): $(NV_NXDC)
	@echo "+ PY\t$^"
	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

# chisel
test:
	mill -i __.test

verilog: build_prepare $(CHISEL_BUILD_VSRC)	

$(CHISEL_BUILD_VSRC): build_prepare
	mill -i __.test.runMain Elaborate -td $(CHISEL_BUILD_PATH)

help:
	mill -i __.test.runMain Elaborate --help

compile:
	mill -i __.compile

bsp:
	mill -i mill.bsp.BSP/install

reformat:
	mill -i __.reformat

checkformat:
	mill -i __.checkFormat

# for all
build_prepare:
# for all
	@if [ ! -d $(BUILD_PATH) ]; then \
	echo "- DIR\t$(BUILD_PATH)"; \
	mkdir -p $(BUILD_PATH); \
	fi
# verilator
	@if [ ! -d $(VAL_BUILD_PATH) ]; then \
	echo "- DIR\t$(VAL_OBJ_PATH)"; \
	mkdir -p $(VAL_OBJ_PATH); \
	echo "- DIR\t$(VAL_BIN_PATH)"; \
	mkdir -p $(VAL_BIN_PATH); \
	fi
# chisel
	@if [ ! -d $(CHISEL_BUILD_PATH) ]; then \
	echo "- DIR\t$(CHISEL_BUILD_PATH)"; \
	mkdir -p $(CHISEL_BUILD_PATH); \
	fi
# nvboard
	@if [ ! -d $(NV_BUILD_PATH) ]; then \
	echo "- DIR\t$(NV_OBJ_PATH)"; \
	mkdir -p $(NV_OBJ_PATH); \
	echo "- DIR\t$(NV_BIN_PATH)"; \
	mkdir -p $(NV_BIN_PATH); \
	fi

clean:
	@if [ -d $(VAL_BUILD_PATH) ]; then \
	echo "- RM\t$(VAL_BUILD_PATH)"; \
	rm -rf $(VAL_BUILD_PATH); \
	fi
	@if [ -d $(CHISEL_BUILD_PATH) ]; then \
	echo "- RM\t$(CHISEL_BUILD_PATH)"; \
	rm -rf $(CHISEL_BUILD_PATH); \
	fi
	@if [ -d $(CHISEL_TEST_DIR) ]; then \
	echo "- RM\t$(CHISEL_TEST_DIR)"; \
	rm -rf $(CHISEL_TEST_DIR); \
	fi
	@if [ -d $(NV_BUILD_PATH) ]; then \
	echo "- RM\t$(NV_BUILD_PATH)"; \
	rm -rf $(NV_BUILD_PATH); \
	fi

cleannv:
	@if [ -d $(NV_BUILD_PATH) ]; then \
	echo "- RM\t$(NV_BUILD_PATH)"; \
	rm -rf $(NV_BUILD_PATH); \
	fi

cleanchi:
	@if [ -d $(CHISEL_BUILD_PATH) ]; then \
	echo "- RM\t$(CHISEL_BUILD_PATH)"; \
	rm -rf $(CHISEL_BUILD_PATH); \
	fi
	@if [ -d $(CHISEL_TEST_DIR) ]; then \
	echo "- RM\t$(CHISEL_TEST_DIR)"; \
	rm -rf $(CHISEL_TEST_DIR); \
	fi

cleanval:
	@if [ -d $(VAL_BUILD_PATH) ]; then \
	echo "- RM\t$(VAL_BUILD_PATH)"; \
	rm -rf $(VAL_BUILD_PATH); \
	fi