[bits 64]

call no_arg_procedure

push 0
call [rbx + 0 * 8]


no_arg_procedure:                  ; no_arg_procedure()

    call _print4
    db "no_arg_procedure()", 0xa, 0
    db 0xCC                         ;debug bp
    _print4:
    call [rbx + 3 * 8]
    add rsp, 8
    ret
; end