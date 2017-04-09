[bits 32]

; main

push 1234 ;2468
call asdf
add esp, 4
push eax
call main_p
    db "Wynik: %i", 0xa, 0
main_p:
 call [ebx + 3 * 4] ;printf("%i", asdf(1234));
add esp, 8

push 0
call [ebx]; exit


asdf: ; asdf(x)[return x*2]

    ;push ebp
    ;mov ebp, esp
    ;sub esp, 4
    enter 4, 0

    mov eax, [ebp + 8]
    add eax, eax
    mov [ebp - 4], eax

    mov eax, [ebp - 4]
    ;leave
    mov esp, ebp
    pop ebp
    ret
