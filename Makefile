CC = gcc
ASM = nasm
CC_OPTS= -std=gnu11 -Wall -O0 -g
SRCDIR=src
APPNAME_86_32 = asmloader32
APPNAME_86_64 = asmloader64
STUB_DIR=stubs
STUB_TARGET_DIR=$(STUB_DIR)/target
EX_DIR=examples
EX_TARGET_DIR=$(EX_DIR)/target

src=$(addprefix $(SRCDIR)/, *.c)
stubs_c=$(addprefix $(STUB_TARGET_DIR)/, x86_32_stub.c x86_64_mswin_stub.c x86_64_linux_stub.c)
stubs_bin=$(addprefix $(STUB_TARGET_DIR)/, x86_32_stub x86_64_mswin_stub x86_64_linux_stub)
bin_ex_32=$(addprefix $(EX_TARGET_DIR)/, 32_call_conv.bin 32_hello.bin 32_stack_frame.bin)
bin_ex_64=$(addprefix $(EX_TARGET_DIR)/, 64_call_conv.bin 64_hello.bin 64_12_printf_args.bin)

$(APPNAME_86_32): $(stubs_c) $(src)
	$(CC) $(CC_OPTS) -m32 $(src) -o $(APPNAME_86_32)

$(APPNAME_86_64): $(stubs_c) $(src)
	$(CC) $(CC_OPTS) $(src) -o $(APPNAME_86_64)

$(stubs_c): $(stubs_bin)
	cd $(STUB_TARGET_DIR) && python stub_to_c.py  && cd -

$(STUB_TARGET_DIR)/%: $(STUB_DIR)/%.nasm
	$(ASM) -o $@ $<

run: run32 run64

run32: $(bin_ex_32) $(APPNAME_86_32)
	for bin in $(EX_TARGET_DIR)/32*.bin; do echo -e "\e[92m\e[1m32 bit exec\e[0m : \e[1m$$bin\e[0m" && ./$(APPNAME_86_32) ./$$bin ; done

run64: $(bin_ex_64) $(APPNAME_86_64)
	for bin in $(EX_TARGET_DIR)/64*.bin; do echo -e "\e[92m\e[1m64 bit exec\e[0m : \e[1m$$bin\e[0m" && ./$(APPNAME_86_64) ./$$bin ; done

$(EX_TARGET_DIR)/%.bin: $(EX_DIR)/%.nasm
	$(ASM) -o $@ $<

.PHONY: clean
clean:
	rm -f $(bin_ex_32)
	rm -f $(bin_ex_64)
	rm -f $(stubs_bin)
	rm -f $(stubs_c)
	rm -f $(APPNAME_86_32)
	rm -f $(APPNAME_86_64)