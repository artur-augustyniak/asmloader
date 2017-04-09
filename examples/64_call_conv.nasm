[bits 64]

call no_arg_procedure1
call no_arg_procedure2

push 0
call [rbx + 0 * 8]

no_arg_procedure1:                  ; no_arg_procedure1()
    call _print
        db "abc1", 0xa, 0
    _print:
    call [rbx + 3 * 8]
    add rsp, 8
    call _print2
        db "cde1", 0xa, 0
        _print2:
        call [rbx + 3 * 8]
    add rsp, 8
    ret
; end

no_arg_procedure2:                  ; no_arg_procedure2()
    call _print3
        db "abc2", 0xa, 0
    _print3:
    call [rbx + 3 * 8]
    call _print4
        db "cde2", 0xa, 0
        _print4:
        call [rbx + 3 * 8]
    add rsp, 16
    ret
; end