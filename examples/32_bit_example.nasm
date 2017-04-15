[bits 32]

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
        db "x86-32 printf(%d %d %d %d %d %d %d %d %d %d %d)", 0xa, 0
    print_hello:
    call [ebx + 3 * 4]
    add esp, 32

call no_arg_procedure2

push 0
call [ebx + 0 * 4]

no_arg_procedure1:                  ; no_arg_procedure1()
    call _print
        db "abc1", 0xa, 0
    _print:
    call [ebx + 3 * 4]
    add esp, 4
    call _print2
        db "cde1", 0xa, 0
        _print2:
        call [ebx + 3 * 4]
    add esp, 4
    ret
; end

no_arg_procedure2:                  ; no_arg_procedure2()
    call _print3
        db "abc2", 0xa, 0
    _print3:
    call [ebx + 3 * 4]
    call _print4
        db "cde2", 0xa, 0
        _print4:
        call [ebx + 3 * 4]
    add esp, 8
    ret
; end