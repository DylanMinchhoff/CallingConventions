section .text
global ccStrLen64
global ccisdigit64
global ccatoi64
global ccmanyArgs64

ccStrLen64:
    push rbx
                            ; arg in rcx 
    xor rbx, rbx            ; zero out rbx

ccStrLen64_lenLoop:
    cmp byte [rcx], 0       ; check for null
    je ccStrLen64_exitLoop

    inc rbx                 ; len++
    inc rcx                 ; ptr++
    jmp ccStrLen64_lenLoop

ccStrLen64_exitLoop:
    mov rax, rbx            ; ret len in ebx

    pop rbx                 ; restore stack
    ret

; checks if isDigit
ccisdigit64:
    push rbx
    xor rax, rax        ; 0 out rax
    cmp byte cl, '0'    ; is greater than 0
    jl  exit_ccisdigit64
    cmp byte cl, '9'
    jg exit_ccisdigit64
    inc rax
exit_ccisdigit64:

    pop rbx
    ret


; 
ccatoi64:    
    push rbx
    sub rsp, 32     ; shaddow space
    
    ;   -8 return value
    ;   -16 is negative
    ;   -24 char*
    xor r8, r8      ; return value 0
    xor r9, r9      ; isNegitive
    mov r10, rcx    ; char* in r10

; check if negitive
    cmp byte [r10], 0x2d
    jne ccatoi64ParseLoop
    inc r10
    inc r9

ccatoi64ParseLoop:

    mov [rbp - 8], r8             ; move ret to stack
    mov [rbp - 16], r9             ; move isNegitive to stack
    mov [rbp - 24] ,r10            ; move char*
    mov cl, [r10]      ; move char[i] to rcx
    call ccisdigit64

    ; capture rsp and rbp
    
    mov r10, [rbp - 24]
    mov r9, [rbp - 16]
    mov r8, [rbp - 8]

    cmp rax, 0x0        ; check if was digit
    je exit_ccatoi64    ; stop at '/0' char or first nonDigit char

    
    ; to digit
    xor rax, rax       ; zero out rax
    
    mov al, [r10]      ; mov char[i] to r11
    sub al, 0x30       ; sub 0x30 '0' to get ascii
    mul r8, 0xa        ; mul by 10
    add r8, rax        ; add next digit
    inc r10            ; char*++

    
    jmp ccatoi64ParseLoop  


exit_ccatoi64:
    cmp r9, 0x0
    je return_ccatoi64
    not r8
    inc r8

return_ccatoi64:
    mov rax, r8
    add rsp, 32
    pop rbx
    ret
    

; ((i1 + i2) * (i3 + i4) * (i5 + i6)) / i7

ccmanyArgs64:
    push rbx
    push rbp
    mov rbp, rsp
    sub rsp, 64
    ; rbp - 8   iv1 (i1 + i2)
    ; rbp - 16  iv2 (i3 + i4)
    ; rbp - 24  iv3 (i5 + i6)

    add rcx, rdx        ; i1 + i2
    mov [rbp - 8], rcx  ; store iv1

    add r8, r9          ; i3 + i4
    mov [rbp - 16], r8  ; store iv2

    ; moving ; 32 bytes shaddow space
    ; rcx -> i5, rdx -> i6, r8 -> i7
    mov rcx, [rbp + 56]
    mov rdx, [rbp + 64]
    mov r8, [rbp + 72]

    add rcx, rdx        ; i5 + i6
    mov [rbp - 24], rcx  ; store iv3

    mov rax, [rbp - 8]  ; rax = iv1
    mov rbx, [rbp - 16] ; rbx = iv2
    imul rax, rbx

    mov rbx, [rbp - 24]        
    imul rax, rbx    ; rax - dividend

    mov rbx, r8     ; rbx - divisor

    cqo
    idiv rbx         ; rax contains lower half of res, rdx contains upper half

    add rsp, 64
    pop rbp
    pop rbx
    ret