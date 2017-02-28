gcc -m32 -std=gnu99 -Wall -pedantic asmloader.c -o asmloader
./asmloader
nasm examples/hello/hello.asm -o examples/hello/hello.bin
./asmloader examples/hello/hello.bin
nasm examples/calling_conventions/func.asm -o examples/calling_conventions/func.bin
./asmloader examples/calling_conventions/func.bin 