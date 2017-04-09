[bits 64]

call no_arg_procedure
push 0
call [rbx + 0 * 8]

no_arg_procedure:
    mov [rel saved_reg], r14
    mov r14, [rsp]              ; save return address, stack will be shattered by vaarg_converter

    call _print
        db "abc", 0xa, 0
    _print:
    call [rbx + 3 * 8]

    call _print2
        db "cde", 0xa, 0
        _print2:
        call [rbx + 3 * 8]

    add rsp, 16

    push r14                    ; sanitize stack?
    mov r14, [rel saved_reg]
    ret

; end

storage_area:
  saved_reg: dq 0