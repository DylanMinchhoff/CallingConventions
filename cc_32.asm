section .text
global _ccStrLen32
global _ccisdigit32
global _ccatoi32

_ccStrLen32:
    push ebp
    mov ebp, esp

    push ebx                ; push stack

    mov eax, [ebp + 8]      
    xor ebx, ebx            ; zero out ebx

ccStrLen32_lenLoop:
    cmp byte [eax], 0       ; check for null
    je ccStrLen32_exitLoop

    inc ebx                 ; len++
    inc eax                 ; ptr++
    jmp ccStrLen32_lenLoop

ccStrLen32_exitLoop:
    mov eax, ebx            ; ret len in ebx

    pop ebx                 ; restore stack
    pop ebp
    ret


; checks if isDigit
_ccisdigit32:
    push ebp
    mov ebp, esp

    xor eax, eax        ; 0 out eax
    mov ecx, [esp + 8]  ; mov first arg char digit to ecx
    cmp byte cl, '0'    ; is greater than 0
    jl  exit_ccisdigit32
    cmp byte cl, '9'
    jg exit_ccisdigit32
    inc eax
exit_ccisdigit32:

    pop ebp
    ret


; 
_ccatoi32:
    push ebp
    mov ebp, esp
    push ebx


    mov ecx, [ebp + 8]; mov char* to ecx
    sub esp, 12
    ; -4 -> char*
    ; -8 -> return value
    ; -12 -> isNegative
    mov dword [ebp - 4], ecx    ; char* (for when needs to be saved)
    mov dword [ebp - 8], 0      ; return value 0
    mov dword [ebp - 12], 0     ; isNegitive        [ebp + 16]



; check if negitive
    cmp byte [ecx], 0x2d
    jne ccatoi32ParseLoop
    mov [ebp - 12], 1
    inc ecx

ccatoi32ParseLoop:

    mov dword [ebp - 4], ecx
    push [ecx]          ; push char[i] to stack
    call _ccisdigit32
    add esp, 4
    mov ecx, [ebp - 4] ; mov char* back
    cmp eax, 0x0        ; check if was digit
    je exit_ccatoi32    ; stop at '/0' char or first nonDigit char

    ; to digit
    xor eax, eax       ; zero out rax
    mov al, [ecx]      ; mov char[i] to r11
    sub al, 0x30       ; sub 0x30 '0' to get ascii
    mov edx, [ebp - 8]
    mul edx, 0xa        ; mul by 10
    add edx, eax        ; add next digit
    mov dword [ebp - 8], edx
    inc ecx            ; char*++
    jmp ccatoi32ParseLoop  


exit_ccatoi32:
    mov dword edx, [ebp - 12]     ; is negitive
    mov eax, [ebp - 8]      ; return value
    cmp edx, 0x0
    je return_ccatoi32
    not eax ; two's compliment
    inc eax

return_ccatoi32:
    pop ebx
    mov esp, ebp
    pop ebp
    ret