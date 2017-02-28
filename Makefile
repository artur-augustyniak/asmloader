CC = gcc
CC_OPTS= -m32 -std=gnu99 -Wall --pedantic
ASM = nasm

APPNAME = asmloader
SRCDIR=src
EX_DIR=examples
TARGETDIR=.
c_files=$(addprefix $(SRCDIR)/, asmloader.c)
bin_files=$(addprefix $(EX_DIR)/, call_conv.bin hello.bin)

$(APPNAME): $(c_files)
	$(CC) $(CC_OPTS) $(c_files) -o $(TARGETDIR)/$(APPNAME)

run: $(bin_files) $(APPNAME)
	for bin in $(EX_DIR)/*.bin; do $(TARGETDIR)/$(APPNAME) ./$$bin; done

$(EX_DIR)/%.bin: $(EX_DIR)/%.asm
	$(ASM) -o $@ $<

.PHONY: clean
clean:
	rm -f $(bin_files)
	rm -f $(APPNAME)


