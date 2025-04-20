ROOT_DIR := $(realpath ../../..)

VORTEX_RT_PATH ?= $(ROOT_DIR)/runtime

#CXXFLAGS += -std=c++17 -Wall -Wextra
CXXFLAGS += -L$(HOME)/llvm/lib -Wl,-rpath,$(HOME)/llvm/lib
CXXFLAGS += -fopenmp -fopenmp-targets=vortex
CXXFLAGS += -Xopenmp-target=vortex --sysroot=$(RISCV_SYSROOT)
CXXFLAGS += -Xopenmp-target=vortex --gcc-toolchain=$(RISCV_TOOLCHAIN_PATH)
CXXFLAGS += -Xopenmp-target=vortex -march=rv64imafd
CXXFLAGS += -Xopenmp-target=vortex -mabi=lp64d
CXXFLAGS += -Xopenmp-target=vortex -mcmodel=medany
CXXFLAGS += -Xopenmp-target=vortex -fno-rtti
CXXFLAGS += -Xopenmp-target=vortex -fno-exceptions
CXXFLAGS += -Xopenmp-target=vortex -nostartfiles
CXXFLAGS += -Xopenmp-target=vortex -nostdlib
CXXFLAGS += -Xopenmp-target=vortex -fdata-sections
CXXFLAGS += -Xopenmp-target=vortex -ffunction-sections
CXXFLAGS += -Xopenmp-target=vortex -Wl,-Bstatic,--gc-sections,-T${VORTEX_HOME}/kernel/scripts/link64.ld,--defsym=STARTUP_ADDR=0x80000000 ${VORTEX_HOME}/build/kernel/libvortex.a
CXXFLAGS += -Xopenmp-target=vortex -L$(TOOLDIR)/riscv64-gnu-toolchain/riscv64-unknown-elf/lib
CXXFLAGS += -Xopenmp-target=vortex -lm
CXXFLAGS += -Xopenmp-target=vortex -lc
CXXFLAGS += -Xopenmp-target=vortex $(TOOLDIR)/libcrt64/lib/baremetal/libclang_rt.builtins-riscv64.a
#CXXFLAGS += -I$(ROOT_DIR)/runtime -L$(ROOT_DIR)/runtime -lvortex


CXX := $(HOME)/llvm/bin/clang++

all: $(PROJECT)

$(PROJECT):
	$(CXX) -O0 -g $(CXXFLAGS) $(SRCS) -o $@

run-simx: $(PROJECT)
	LIBOMPTARGET_DEBUG=1 \
	LD_LIBRARY_PATH=$(HOME)/llvm/lib:$(VORTEX_RT_PATH):$(LLVM_VORTEX)/lib:$(LD_LIBRARY_PATH)  \
	VORTEX_DRIVER=simx ./$(PROJECT) $(OPT)

run-rtlsim: run-simx

clean:
	rm -f *.o $(PROJECT)