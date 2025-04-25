; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9
; Floating Point
; L/W ABI: xmm0, xmm1,...
;
; extern "C" Int64 Cc1_(int8_t a, int16_t b, int32_t c, int64_t d, int8_t e, int16_t f,
; int32_t g, int64_t h);
section .data
   %define RBP_OFFSET 16 ; Adjusted this value

section .text
    global Cc1_

Cc1_:
    ; Function prologue
    push rbp ; save caller's rbp reg
    mov rbp, rsp ; update frame pointer
    sub rsp, 16 ; allocate stack space for local variables

    ; Process first 6 args which are in registers in Linux ABI
    movsx rax, dil ; a (8-bit)
    movsx rcx, si ; b (16-bit)
    movsxd rdx, edx ; c (32-bit)
    ; d is already in rcx as 64-bit
    movsx r10, r8b ; e (8-bit)
    movsx r11, r9w ; f (16-bit)

    ; Calculate a+b+c+d
    add rax, rcx ; a+b
    add rdx, r8 ; c+d
    add rax, rdx ; a+b+c+d
    mov [rbp-8], rax ; store this temporarily

    ; Get g and h from stack (7th and 8th parameters)
    movsxd r8, dword [rbp+16]  ; g (7th param) - 32-bit
    mov r9, [rbp+24]           ; h (8th param) - 64-bit

    ; Calculate e+f+g+h
    add r10, r11 ; e+f
    add r8, r9 ; g+h
    add r10, r8 ; e+f+g+h

    ; Calculate final result
    mov rax, [rbp-8]
    add rax, r10 ; (a+b+c+d) + (e+f+g+h)

    ; Function epilogue
    mov rsp, rbp ; restore stack pointer
    pop rbp ; restore base pointer
    ret

section .note.GNU-stack
