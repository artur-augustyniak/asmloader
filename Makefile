CC = gcc
CC_OPTS= -std=gnu11 -Wall
86_32_ARCH= -m32
ASM = nasm

APPNAME_86_32 = asmloader32
APPNAME_86_64 = asmloader64
SRCDIR=src
EX_DIR=examples
TARGETDIR=.
c_files=$(addprefix $(SRCDIR)/, asmloader.c)
bin_files32=$(addprefix $(EX_DIR)/, call_conv32.bin hello32.bin)
bin_files64=$(addprefix $(EX_DIR)/, hello64.bin)

$(APPNAME_86_32): $(c_files)
	$(CC) $(CC_OPTS) $(86_32_ARCH) $(c_files) -o $(TARGETDIR)/$(APPNAME_86_32)

$(APPNAME_86_64): $(c_files)
	$(CC) $(CC_OPTS) $(c_files) -o $(TARGETDIR)/$(APPNAME_86_64)

run32: $(bin_files32) $(APPNAME_86_32)
	for bin in $(EX_DIR)/*32.bin; do $(TARGETDIR)/$(APPNAME_86_32) ./$$bin; done

run64: $(bin_files64) $(APPNAME_86_64)
	for bin in $(EX_DIR)/*64.bin; do $(TARGETDIR)/$(APPNAME_86_64) ./$$bin; done

$(EX_DIR)/%.bin: $(EX_DIR)/%.asm
	$(ASM) -o $@ $<

.PHONY: clean
clean:
	rm -f $(bin_files32)
	rm -f $(bin_files64)
	rm -f $(APPNAME_86_32)
	rm -f $(APPNAME_86_64)


