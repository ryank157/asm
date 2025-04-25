; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9
; Floating Point
; L/W ABI: xmm0, xmm1,...
;
; extern "C" Int64 Cc1_(int8_t a, int16_t b, int32_t c, int64_t d, int8_t e, int16_t f,
; int32_t g, int64_t h);

section .data
   %define RBP_OFFSET 24

section .text
    global Cc1_
    global Prolog

Prolog:
    push rbp ; save caller's rbp reg
    ; .pushreg rbp ; assembler directive - commented out
    sub rsp, 16 ; alloc for local vars
    ; .allocstack 16 ; assembler directive - commented out
    mov rbp, rsp ; update frame
    ; .setframe rbp, 0 ; assembler directive - commented out
    ; .endprolog ; assembler directive - commented out

Cc1_:
    movsx rdi, dil ; a (corrected rdw to dil)
    movsx rsi, si ; b (corrected rsw to si)
    movsxd rdx, edx ; c
    add rdi, rsi ; a+b
    add rdx, rcx ; c+d
    add rdx, rdi ; a+b+c+d
    mov [rbp], rdx
    movsx r8, r8b ; e (corrected r8w to r8b)
    movsx r9, r9w ; f (corrected r9d to r9w)
    movsxd rdx, dword [rbp + RBP_OFFSET + 8]  ; g
    add r8, r9 ; e+f
    add rdx, [rbp + RBP_OFFSET + 16]  ; g + h
    add rdx, r8 ; e+f+g+h
    mov rax, [rbp]
    add rax, rdx ; final sum
    add rsp, 16
    pop rbp
    ret

section .note.GNU-stack
