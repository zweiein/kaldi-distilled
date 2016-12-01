# This file was generated using the following command:
# ./configure --shared --mkl-root=/opt/intel/mkl --mkl-libdir=/opt/intel/mkl/lib/intel64 --mathlib=MKL --use-cuda=yes --cudatk-dir=/usr/local/cuda

# Rules that enable valgrind debugging ("make valgrind")

valgrind: .valgrind

.valgrind:
	echo -n > valgrind.out
	for x in $(TESTFILES); do echo $$x>>valgrind.out; valgrind ./$$x >/dev/null 2>> valgrind.out; done
	! ( grep 'ERROR SUMMARY' valgrind.out | grep -v '0 errors' )
	! ( grep 'definitely lost' valgrind.out | grep -v -w 0 )
	rm valgrind.out
	touch .valgrind


KALDI_FLAVOR := dynamic
KALDILIBDIR := /home/yang/kaldi-distilled/src/lib
CONFIGURE_VERSION := 2
FSTROOT = /home/yang/kaldi-distilled/tools/openfst
OPENFST_VER = 1.4.1
OPENFST_GE_10400 = 1
EXTRA_CXXFLAGS += -DHAVE_OPENFST_GE_10400 -std=c++0x
OPENFSTLIBS = -L/home/yang/kaldi-distilled/tools/openfst/lib -lfst
OPENFSTLDFLAGS = -Wl,-rpath=/home/yang/kaldi-distilled/tools/openfst/lib
MKLROOT = /opt/intel/mkl
MKLLIB = /opt/intel/mkl/lib/intel64
# You have to make sure MKLROOT and (optionally) MKLLIB is set

# We have tested Kaldi with MKL version 10.2 on Linux/GCC and Intel(R) 64 
# architecture (also referred to as x86_64) with LP64 interface layer.

# The linking flags for MKL will be very different depending on the OS, 
# architecture, compiler, etc. used. The correct flags can be obtained from
# http://software.intel.com/en-us/articles/intel-mkl-link-line-advisor/
# Use the options obtained from this website to manually configure for other
# platforms using MKL.

ifndef MKLROOT
$(error MKLROOT not defined.)
endif

ifndef FSTROOT
$(error FSTROOT not defined.)
endif

MKLLIB ?= $(MKLROOT)/lib/em64t

CXXFLAGS = -m64 -msse -msse2 -pthread -Wall -I.. \
      -DKALDI_DOUBLEPRECISION=0 -DHAVE_POSIX_MEMALIGN \
      -Wno-sign-compare -Wno-unused-local-typedefs -Winit-self \
      -DHAVE_EXECINFO_H=1 -rdynamic -DHAVE_CXXABI_H \
      -DHAVE_MKL -I$(MKLROOT)/include \
      -I$(FSTROOT)/include \
      $(EXTRA_CXXFLAGS) \
      -g # -O0 -DKALDI_PARANOID

ifeq ($(KALDI_FLAVOR), dynamic)
CXXFLAGS += -fPIC
endif

## Use the following for STATIC LINKING of the SEQUENTIAL version of MKL
MKL_STA_SEQ = $(MKLLIB)/libmkl_solver_lp64_sequential.a -Wl,--start-group \
	$(MKLLIB)/libmkl_intel_lp64.a $(MKLLIB)/libmkl_sequential.a \
	$(MKLLIB)/libmkl_core.a -Wl,--end-group -lpthread

## Use the following for STATIC LINKING of the MULTI-THREADED version of MKL
MKL_STA_MUL = $(MKLLIB)/libmkl_solver_lp64.a -Wl,--start-group \
	$(MKLLIB)/libmkl_intel_lp64.a $(MKLLIB)/libmkl_intel_thread.a \
	$(MKLLIB)/libmkl_core.a -Wl,--end-group $(MKLLIB)/libiomp5.a -lpthread

## Use the following for DYNAMIC LINKING of the SEQUENTIAL version of MKL
MKL_DYN_SEQ = -L$(MKLLIB) -lmkl_solver_lp64_sequential -Wl,--start-group \
	-lmkl_intel_lp64 -lmkl_sequential -lmkl_core -Wl,--end-group -lpthread

## Use the following for DYNAMIC LINKING of the MULTI-THREADED version of MKL
MKL_DYN_MUL = -L$(MKLLIB) -lmkl_solver_lp64 -Wl,--start-group -lmkl_intel_lp64 \
	-lmkl_intel_thread -lmkl_core -Wl,--end-group -liomp5 -lpthread

# MKLFLAGS = $(MKL_DYN_MUL)

LDFLAGS = -rdynamic -L$(FSTROOT)/lib -Wl,-R$(FSTROOT)/lib
LDLIBS =  $(EXTRA_LDLIBS) -lfst -ldl $(MKLFLAGS) -lm -lpthread
CC = g++
CXX = g++
AR = ar
AS = as
RANLIB = ranlib
MKLFLAGS = -L/opt/intel/mkl/lib/intel64  -Wl,-rpath=/opt/intel/mkl/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -liomp5 -lpthread -lm -L/opt/intel/compilers_and_libraries_2016.1.150/linux/compiler/lib/intel64_lin -Wl,-rpath=/opt/intel/compilers_and_libraries_2016.1.150/linux/compiler/lib/intel64_lin 

#Next section enables CUDA for compilation
CUDA = true
CUDATKDIR = /usr/local/cuda

CUDA_INCLUDE= -I$(CUDATKDIR)/include
CUDA_FLAGS = -g -Xcompiler -fPIC --verbose --machine 64 -DHAVE_CUDA

CXXFLAGS += -DHAVE_CUDA -I$(CUDATKDIR)/include 
UNAME := $(shell uname)
#aware of fact in cuda60 there is no lib64, just lib.
ifeq ($(UNAME), Darwin)
CUDA_LDFLAGS += -L$(CUDATKDIR)/lib -Wl,-rpath,$(CUDATKDIR)/lib
else
CUDA_LDFLAGS += -L$(CUDATKDIR)/lib64 -Wl,-rpath,$(CUDATKDIR)/lib64
endif
CUDA_LDLIBS += -lcublas -lcudart #LDLIBS : The libs are loaded later than static libs in implicit rule


CXXFLAGS += -DHAVE_SPEEX -I/home/yang/kaldi-distilled/src/../tools/speex/include
LDLIBS += -L/home/yang/kaldi-distilled/src/../tools/speex/lib -lspeex
LDFLAGS += -Wl,-rpath=/home/yang/kaldi-distilled/src/../tools/speex/lib
