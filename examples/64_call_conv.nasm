[bits 64]

call no_arg_procedure

push 0
call [rbx + 0 * 8]

no_arg_procedure:                  ; no_arg_procedure()

    ;push 42
    call _print
        db "abc", 0xa, 0
    _print:
    call [rbx + 3 * 8]

    ;push 42
    call _print2
        db "cde", 0xa, 0
        _print2:
        call [rbx + 3 * 8]


    add rsp, 16
    ;add rsp, 8
    ret
; end