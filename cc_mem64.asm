section .text
global ccmemcpy64
global ccmemset64

; @ccmemcpy_64
; 64bit memcpy
;
; args
;
; rcx  uint8_t*     dest
; rdx  uint8_t*     src
; r8   sizet_n      copy
;
; *NOTE this function does not have a trace attached
ccmemcpy64:
    push rbx                ; save base ptr
    mov rax, rcx            ; return dest add
                            ; arg in rcx
ccmemcpy64Loop:
    cmp r8, 0               ; r8 contains the size (not a ptr)
    je ccmemcpy64_exitLoop  

    mov al, [rdx]           ; tmp = src
    mov [rcx], al           ; dest = tmp
    inc rdx                 ; dst++
    inc rcx                 ; src++
    dec r8                  ; size--
    jmp ccmemcpy64Loop

ccmemcpy64_exitLoop:
    pop rbx                 ; restore stack
    ret

; @ccmemset_64
; 64bit memset
;
; args
;
; rcx  uint8_t*     dest
; rdx  uint32_t     c
; r8   sizet_n      n
ccmemset64:
    push rbx
    mov rax, rcx

ccmemset64Loop:
    cmp r8, 0
    je ccmemset64ExitLoop

    mov [rcx], rdx  ; 
    inc rcx         ; d
    dec r8          ; n--
    jmp ccmemset64Loop
ccmemset64ExitLoop:
    pop rbx
    ret
