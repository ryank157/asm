; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

; Floating Point
; L/W ABI: xmm0, xmm1,...

; extern "C" bool AvxCalcSqrts_(float* y, const float* x, size_t n);
section .text
    global AvxCalcSqrts_

AvxCalcSqrts_:
xor eax, eax

    ; check if n is valid
    test rdx, rdx
    jle Done

    ; check if x, y aligned
    test rsi, 0fh ; if final 4 bits aren't 0, then that means address is 1-15 instead of aligned to boundary
    jnz Done
    test rdi, 0fh
    jnz Done

    ; Perform Simd calcs
    mov rcx, 0
    cmp rdx, 4 ; 4 wide simd because of 4 byte float
    jb FinalVals

SqrtLoop:
    vsqrtps xmm0, [rsi + rcx] ; xmm0 = sqrt(x[i+3:i])
    vmovaps [rdi + rcx], xmm0 ; y[i+3:i] =result

    add rcx, 16
    sub rdx, 4
    cmp rdx, 4
    jae SqrtLoop

FinalVals:
    test rdx, rdx
    jz SetRC

    vxorps xmm1, xmm1, xmm1 ; Use clean high bits for answer
   .IndividualLoop:
    vsqrtss xmm0, xmm1, [rsi + rcx]
    vmovss [rdi + rcx], xmm0
    add rcx,4
    dec rdx
    jnz .IndividualLoop


SetRC:
    mov eax, 1
Done:
    ret
section .note.GNU-stack
