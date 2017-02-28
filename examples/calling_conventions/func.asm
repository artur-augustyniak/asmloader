[bits 32]

mov eax, 12345678
call print_int1

push 987654321
call print_int2
add esp, 4

push 55667788
call print_int3

call print_asdf
call print_asdf
call print_asdf
call print_asdf


push 0
call [ebx]; exit(0)

; fastcall:eax
; print_int1(int)
print_int1:
    push eax
    call _print1
    db "print_int1: %i", 0xa, 0
    _print1:
    call [ebx + 3 * 4] ;printf
    add esp, 8
    ret
;end


; cdecl
; print_int2(int)
print_int2:
    ; esp - > [RET][arg]
    push dword [esp + 4]
    ; esp -> [arg][RET][arg]
    call _print2
    db "print_int2: %i", 0xa, 0
    _print2:
    call [ebx + 3 * 4] ;printf
    add esp, 8
    ret
;end

; stdcall
; print_int3(int)
print_int3:
    push dword [esp + 4]
    call _print3
    db "print_int3: %i", 0xa, 0
    _print3:
    call [ebx + 3 * 4] ;printf
    add esp, 8
    retn 4
;end


; print_asdf()
print_asdf:
    call _print4
    db "print_asdf - bez argumentow", 0xa, 0
    _print4:
    call [ebx + 3 * 4] ;printf
    add esp, 4
    ret
;end
