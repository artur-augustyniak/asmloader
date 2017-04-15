[bits 64]
[org 0xcdcdcdcdcdcdc000]  ; Used for pseudo-relocations.

start:
  lea rbx, [rel jump_table]    ; Wrapped API.
  lea rcx, [rel import_table]  ; Platform-specific API.
  jmp real_start

stub_exit:
  mov rdi, [rsp+8]
  jmp [rel import_exit]
  ; Should not return.

stub_putchar:
  mov [rel saved_rdi], rdi
  mov rdi, [rsp+8]
  call [rel import_putchar]
  mov rdi, [rel saved_rdi]
  ret  

stub_getchar:
  jmp [rel import_getchar]

stub_printf:
  ; Note: Floating points won't work, as there is no easy way to detect which
  ;       argument on the stack is a floating point (and should be moved to xmm
  ;       registers). If this is reaaaaaalllyyyyy needed in the future, one can
  ;       write a format string parser to figure out where the %f/etc are
  ;       placed. But that seems to complicated for a simple app like this one.
  push qword [rel import_printf]
  jmp vaarg_converter

stub_scanf:
  push qword [rel import_scanf]
  jmp vaarg_converter

; Expects function-to-be-called's address on the stack.
vaarg_converter:
  ; Order of arguments: rdi, rsi, rdx, rcx, r8, r9, <stack>
  mov [rel saved_r15], r15
  mov [rel saved_rdi], rdi
  mov [rel saved_rsi], rsi
  mov [rel saved_rdx], rdx
  mov [rel saved_rcx], rcx
  mov [rel saved_r8], r8
  mov [rel saved_r9], r9

  pop rdx  ; Function to be called.
  pop r15  ; Return address.
  mov [rel saved_ret], r15
  mov r15, rdx

  mov rdi, [rsp+8*0]
  mov rsi, [rsp+8*1]
  mov rdx, [rsp+8*2]
  mov rcx, [rsp+8*3]
  mov r8, [rsp+8*4]
  mov r9, [rsp+8*5]

  ; remove args passed via registers from stack to avoid printing
  ; them next time in case of more than 6 printf arguments
  ; no easy way to detect exact number of arguments so we have to save stack
  ; to rebuild it in case of less then 6 params
  mov [rel saved_stack_top], rdi
  mov [rel saved_stack_nd], rsi
  mov [rel saved_stack_rd], rdx
  mov [rel saved_stack_fourth], rcx
  mov [rel saved_stack_fifth], r8
  mov [rel saved_stack_sixth], r9
  add rsp, 48

  ; When calling printf stub uses rax, so this register is nonzero.
  ; This causes printf to "see" floating point arguments and starts using SSE.
  ; At the same time if the stack does not have the proper 16 byte alignment asmloader will crash.
  ; After first call [rbx + 3 * 8] call rax may be nonzero again
  ; so code like:
  ; [bits 64]
  ;
  ; call no_arg_procedure
  ;
  ; push 0
  ; call [rbx + 0 * 8]
  ;
  ; no_arg_procedure:                  ; no_arg_procedure()
  ;
  ;    call _print
  ;         db "abc", 0xa, 0
  ;     _print:
  ;     call [rbx + 3 * 8]
  ;     add rsp, 8
  ;
  ;     call _print2
  ;         db "cde", 0xa, 0
  ;         _print2:
  ;         call [rbx + 3 * 8]
  ;     add rsp, 8
  ;     ret
  ;  ;end
  ; will leave stack unaligned and nonzero rax, this will crash, so:
  xor rax, rax
  call r15

  ; restore 6 stack elements
  push QWORD [rel saved_stack_sixth]
  push QWORD [rel saved_stack_fifth]
  push QWORD [rel saved_stack_fourth]
  push QWORD [rel saved_stack_rd]
  push QWORD [rel saved_stack_nd]
  push QWORD [rel saved_stack_top]

  mov rdi, [rel saved_rdi]
  mov rsi, [rel saved_rsi]
  mov rdx, [rel saved_rdx]
  mov rcx, [rel saved_rcx]
  mov r8, [rel saved_r8]
  mov r9, [rel saved_r9]


  ; r12, r13, r14, r15, rbx, rsp, rbp are the callee-saved registers - they have a
  ; "Yes" in the "Preserved across function calls" column.
  mov r15, [rel saved_r15]
  jmp [rel saved_ret]

; Attempt to move out the data part to another cache-line.
times (0x200 - ($ - start)) db 0x00

jump_table:
  dq stub_exit
  dq stub_putchar
  dq stub_getchar
  dq stub_printf
  dq stub_scanf

import_table:
  import_exit:     dq 0xc0dec0dec0de0000
  import_putchar:  dq 0xc0dec0dec0de0001
  import_getchar:  dq 0xc0dec0dec0de0002
  import_printf:   dq 0xc0dec0dec0de0003
  import_scanf:    dq 0xc0dec0dec0de0004

storage_area:
  saved_rdi: dq 0
  saved_rsi: dq 0
  saved_rdx: dq 0
  saved_rcx: dq 0
  saved_r8: dq 0
  saved_r9: dq 0
  saved_r15: dq 0
  saved_ret: dq 0
  ; space for saving 6 params taken off the stack
  saved_stack_top: dq 0
  saved_stack_nd: dq 0
  saved_stack_rd: dq 0
  saved_stack_fourth: dq 0
  saved_stack_fifth: dq 0
  saved_stack_sixth: dq 0

; Align to STUB_SIZE.
times (0x400 - ($ - start)) db 0x0
real_start:


