ifeq ($(DEBUG),)
DEBUG_C  := -g
DEBUG_AS := -g -F dwarf
endif

CC = gcc
CC_FLAGS = $(DEBUG_C) -ffreestanding -O2 -c

AS = nasm
AS_FLAGS = $(DEBUG_AS) -felf64

LD = ld.lld
LD_FLAGS = -nostdlib