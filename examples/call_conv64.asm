[bits 64]
; gynvael.coldwind.pl/?id=641
; http://gynvael.coldwind.pl/?id=387


call no_arg_procedure

push 0
call [rbx + 0 * 8]


no_arg_procedure:                  ; no_arg_procedure()

    push 3534
    call nd
    db "abc", 0xa, 0
    nd:
    call [rbx+3*8]


    add rsp, 16
    ret
; end