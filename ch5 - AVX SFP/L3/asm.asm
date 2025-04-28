; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

; Floating Point
; L/W ABI: xmm0, xmm1,...

; extern "C" double CalcDistance_(double x1, double y1, double z1, double x2, double y2,
; double z2)
section .text
    global CalcDistance_

CalcDistance_:
    ; x1 in xmm0
    ; y1 in xmm1
    ; z1 in xmm2
    ; x2 in xmm3
    ; y2 in xmm4
    ; z2 in xmm5
    ;
    ; x2-x1 in xmm6
    ; y2-y1 in xmm7
    ; z2-z1 in xmm8
    vsubsd xmm6, xmm3, xmm0 ; xmm6 = x2-x1
    vsubsd xmm7, xmm4, xmm1 ; xmm7 = y2-y1
    vsubsd xmm8, xmm5, xmm2 ; xmm8 = z2-z1

    vmulsd xmm6, xmm6, xmm6
    vmulsd xmm7, xmm7, xmm7
    vmulsd xmm8, xmm8, xmm8

    vaddsd xmm6, xmm6, xmm7
    vaddsd xmm6, xmm6, xmm8
    vsqrtsd xmm0, xmm0, xmm6



    ret
section .note.GNU-stack
