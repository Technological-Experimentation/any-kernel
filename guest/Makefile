-include ../compiler.mk
LD_FLAGS += -T link.ld

SRC = $(shell find ./ -type f -name '*.c')
ASM = $(shell find ./ -type f -name '*.asm')
OBJ = $(ASM:.asm=.asm.o) $(SRC:.c=.c.o)
GUEST = image.elf

all: $(GUEST)
	@printf "OK Built guest\n"

$(GUEST) : $(OBJ)
	$(LD) $(LD_FLAGS) $^ -o $@

%.c.o: %.c
	@printf "CC $<\n"
	$(CC) $(CC_FLAGS) $< -o $@

%.asm.o: %.asm
	@printf "AS $<\n"
	$(AS) $(AS_FLAGS) $< -o $@

clean:
	rm -rf $(OBJ) $(GUEST)