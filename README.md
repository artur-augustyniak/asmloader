#Simplified Assembly Loader v.0.0.2 
##by gynvael.coldwind//vx
[http://gynvael.coldwind.pl/](http://gynvael.coldwind.pl/)

###License Stuff

Copyright (C) 2011 by Gynvael Coldwind

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


###Build

Build asmloader
```
$ cd asmloader
$ make
```
Build asmloader, compile all  *.asm files in `examples` and run them usin asmloader binary
 ```
$ cd asmloader
$ make run 
```
 
###Usage
```
  asmloader <file.bin>
```
###What this does (in short):
1. It allocated memory for Read/Write/Execute
2. Loads the specified file to it
3. And jumps to it (i.e. executes the binary code that was in the file)

####It provides a minor API set.
File.bin should be pure assembly code, without any headers.
Your code will be loaded to a `random page address + 0x100`.
In `EBX/RBX` register there is a pointer to an array of functions:
 * 0 exit
 * 1 putchar
 * 2 getchar
 * 3 printf
 * 4 scanf
 
You have to use the calling convention of your platform, being:
* Windows/Linux 32-bit: cdecl (arguments to stack, you clean the stack afterwards)
* Windows       64-bit: fastcall (Windows x64)
* Linux         64-bit: fastcall (System V AMD64 ABI)

See [http://en.wikipedia.org/wiki/X86_calling_conventions](http://en.wikipedia.org/wiki/X86_calling_conventions) for details.
 
Whatever you return in `EAX` will be what the program returns at exit.
However, if you decide to return, remember to backup non-volatile registers first ;)
Or... use exit function to exit, e.g. (32-bit example):
```
  push dword 0
  call [ebx+0]
```
If you neither exit nor return properly, the program will crash.
Have fun :)


###Changelog:
* 0.0.1 -> 0.0.2: Added a warning in case source code file is detected as first argument.