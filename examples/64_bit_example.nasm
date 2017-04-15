[bits 64]

call no_arg_procedure1
call no_arg_procedure2

    push 11
    push 10
    push 9
    push 8
    push 7
    push 6
    push 5
    push 4
    push 3
    push 2
    push 1
    call print_hello
        db "x86-64 printf(%d %d %d %d %d %d %d %d %d %d %d)", 0xa, 0
    print_hello:
    call [rbx+3*8]
    add rsp, 64

call no_arg_procedure2

push 0
call [rbx]

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