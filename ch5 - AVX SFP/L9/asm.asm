; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9
; Floating Point
; L/W ABI: xmm0, xmm1,...

; Define macros for function prologue and epilogue
   %macro FUNCTION_PROLOGUE 1 ; Parameter is the stack space to allocate
    push rbp ; save caller's rbp reg
    mov rbp, rsp ; update frame pointer
    sub rsp, %1 ; allocate stack space for local variables
   %endmacro

   %macro FUNCTION_EPILOGUE 0 ; No parameters needed
    mov rsp, rbp ; restore stack pointer
    pop rbp ; restore base pointer
    ret ; return to caller
   %endmacro

section .data
   %define RBP_OFFSET 16 ; Adjusted this value

section .text
    global Cc1_

Cc1_:
    ; Function prologue
    FUNCTION_PROLOGUE 16 ; Allocate 16 bytes of stack space

    ; Process first 6 args which are in registers in Linux ABI
    movsx rax, dil ; a (8-bit)
    movsx rsi, si ; b (16-bit)
    movsxd rdx, edx ; c (32-bit)
    ; d is already in rcx as 64-bit
    movsx r8, r8b ; e (8-bit)
    movsx r9, r9w ; f (16-bit)

    ; Calculate a+b+c+d
    add rax, rsi ; a+b
    add rdx, rcx ; c+d
    add rax, rdx ; a+b+c+d
    mov [rbp-8], rax ; store this temporarily

    ; Get g and h from stack (7th and 8th parameters)
    movsxd r10, dword [rbp+RBP_OFFSET]    ; g (7th param) - 32-bit
    mov r11, [rbp+RBP_OFFSET+8]           ; h (8th param) - 64-bit

    ; Calculate e+f+g+h
    add r8, r9 ; e+f
    add r10, r11 ; g+h
    add r10, r8 ; e+f+g+h

    ; Calculate final result
    mov rax, [rbp-8]
    add rax, r10 ; (a+b+c+d) + (e+f+g+h)

    ; Function epilogue
    FUNCTION_EPILOGUE

section .note.GNU-stack
