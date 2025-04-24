; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9
;
; extern "C" int ReverseArray_(int* y, const int* x, int n);
;
; Returns 0 = invalid n, 1 = success
section .text
    global ReverseArray_

ReverseArray_:

    xor eax, eax ; return code
    test dx, dx ; n is valid
    jle InvalidArg

    ; rdi = y
    ; rsi = x
    ; rdx = n
    mov rcx, rdx
    lea rsi, [rsi + rcx*4 -4]

    pushfq ; Save caller flags
    std ; RFLAGS.DF = 1

   .LoopReversal:
    lodsd ; eax = *x--
    mov [rdi], eax ; *y = eax
    add rdi, 4 ; y++
    dec rcx, ; n--
    jnz .LoopReversal

    popfq
    mov eax,1


InvalidArg:

    ret
section .note.GNU-stack
