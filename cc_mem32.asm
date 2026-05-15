section .text
global _ccmemcpy32
global _ccmemset32

; @ccmemcpy_32
; 32bit memcpy
;
; args
;
; uint8_t*     dest
; uint8_t*     src
; sizet_n      copy size
_ccmemcpy32:
    push ebp
    mov ebp, esp
    push ebx

    mov eax, [ebp + 8]      ; dest
    mov ebx, [ebp + 12]     ; src
    mov ecx, [ebp + 16]     ; n
ccmemcpy32_loop:
    cmp ecx, 0
    je exit_ccmemcpy32
    mov dl, [ebx]
    mov [eax], dl
    inc eax
    inc ebx
    dec ecx
    jmp ccmemcpy32_loop
exit_ccmemcpy32:
    mov eax, [ebp + 8]      ; mov the original dest ptr back to eax
    pop ebx
    pop ebp
    ret

; @ccmemset_32
; 32bit memset
;
; uint8_t*     dest
; uint32_t     c
; sizet_n      n
_ccmemset32:
    push ebp
    mov ebp, esp
    push ebx

    mov eax, [ebp + 8]      ; dest
    mov ebx, [ebp + 12]     ; c
    mov ecx, [ebp + 16]     ; n
ccmemset32Loop:
    cmp ecx, 0
    je ccmemset32ExitLoop

    mov [eax], ebx  ; 
    inc eax         ; d
    dec ecx          ; n--
    jmp ccmemset32Loop
ccmemset32ExitLoop:
    mov eax, [ebp + 8]      ; mov the original dest ptr back to eax

    pop ebx
    pop ebp
    ret