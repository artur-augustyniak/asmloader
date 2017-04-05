[bits 32]
; ################## STACK LEGEND ########################
; STACK [][][456] -> to lower addresses
; ########################################################
                            ; MAIN


; ################## FASTCALL ############################
mov eax, 123                ; int eax = 123
                            ; STACK [][]
call print_fastcall         ; print_fastcall(eax)
                            ; no caller cleanup


; ################## CDECL ###############################
push 456                    ; int a = 456
                            ; STACK [][][456]
call print_cdecl            ; print_cdecl(a)
add esp, 4                  ; caller stack cleanup
                            ; STACK [][]


; ################## STDCALL #############################
push 789                    ; int a = 789
                            ; STACK [][][789]
call print_stdcall          ; print_stdcall(a)
                            ; no caller cleanup


; ################## PLAIN (NO ARGS) #####################
call no_arg_procedure

; ################## MAIN EXIT ###########################
push 0                      ; cdecl return code
call [ebx + 0 * 4]          ; exit(0)
                            ; MAIN END


;########################################################
;############## FUNCTION DEFINITIONS ####################
;########################################################
print_fastcall:                     ; print_fastcall(eax)
    push eax                        ; last printf arg
    call _print1
    db "print_fastcall(%i);", 0xa, 0 ; fmt string
    _print1:                        ; STACK [][RET][EAX][FMT]
    call [ebx + 3 * 4]              ; printf
    add esp, 8                      ; clean up stack fmt and local arg
                                    ; STACK [][RET]
    ret                             ; pop return address and jump
; end


print_cdecl:                        ; print_cdecl(a)
                                    ; STACK [][a][RET]
    push dword [esp + 4]            ; STACK [][a][RET][a]
    call _print2
    db "print_cdecl(%i);", 0xa, 0   ; fmt string
    _print2:                        ; STACK [][a][RET][a][FMT]
    call [ebx + 3 * 4]              ; printf
    add esp, 8                      ; clean up stack fmt and local arg
                                    ; STACK [][a][RET]
    ret                             ; pop return address and jump
; end


print_stdcall:                      ; print_stdcal(a)
                                    ; STACK [][a][RET]
    push dword [esp + 4]            ; STACK [][a][RET][a]
    call _print3
    db "print_stdcall(%i);", 0xa, 0 ; fmt string
    _print3:                        ; STACK [][a][RET][a][FMT]
    call [ebx + 3 * 4]              ; printf
    add esp, 8                      ; clean up stack fmt and local arg
                                    ; STACK [][a][RET]
    retn 4                          ; cleanup stack after popping RET
; end                               ; STACK []


no_arg_procedure:                  ; no_arg_procedure()
                                   ; STACK [][RET]
    call _print4
    db "no_arg_procedure()", 0xa, 0; printf string param
    _print4:                       ; STACK [][RET][STRING]
    call [ebx + 3 * 4]             ; printf
    add esp, 4                     ; clean up stack local arg
                                   ; STACK [][RET]
    ret                            ; pop return address and jump
; end