; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9
;
; Floating Point
; L/W ABI: xmm0, xmm1,...

section .data
    align 16
    AbsMaskF32 dd 0x7fffffff, 0x7fffffff, 0x7fffffff, 0x7fffffff ; Absolute value mask for SPFP
    ; Could include second align 16, but unnecessary
    AbsMaskF64 dq 0x7fffffffffffffff, 0x7fffffffffffffff ; Absolute value mask for DPFP

section .text
    global AvxPackedMathF32_
    global AvxPackedMathF64_

AvxPackedMathF32_:
    vmovaps xmm0, [rdi]        ; xmm0 = a
    vmovaps xmm1, [rsi]        ; xmm1 = b

    ; Packed SPFP addition
    vaddps xmm2, xmm0, xmm1
    vmovaps [rdx+0], xmm2

    ; Packed SPFP subtraction
    vsubps xmm2, xmm0, xmm1
    vmovaps [rdx+16], xmm2

    ; Packed SPFP multiplication
    vmulps xmm2, xmm0, xmm1
    vmovaps [rdx+32], xmm2

    ; Packed SPFP division
    vdivps xmm2, xmm0, xmm1
    vmovaps [rdx+48], xmm2

    ; Packed SPFP absolute value (b)
    vandps xmm2, xmm1, [rel AbsMaskF32]
    vmovaps [rdx+64], xmm2

    ; Packed SPFP square root (a)
    vsqrtps xmm2, xmm0
    vmovaps [rdx+80], xmm2

    ; Packed SPFP minimum
    vminps xmm2, xmm0, xmm1
    vmovaps [rdx+96], xmm2

    ; Packed SPFP maximum
    vmaxps xmm2, xmm0, xmm1
    vmovaps [rdx+112], xmm2
    ret

AvxPackedMathF64_:
    ; Load packed DPFP values
    vmovapd xmm0, [rdi]        ; xmm0 = a
    vmovapd xmm1, [rsi]        ; xmm1 = b

    ; Packed DPFP addition
    vaddpd xmm2, xmm0, xmm1
    vmovapd [rdx+0], xmm2

    ; Packed DPFP subtraction
    vsubpd xmm2, xmm0, xmm1
    vmovapd [rdx+16], xmm2

    ; Packed DPFP multiplication
    vmulpd xmm2, xmm0, xmm1
    vmovapd [rdx+32], xmm2

    ; Packed DPFP division
    vdivpd xmm2, xmm0, xmm1
    vmovapd [rdx+48], xmm2

    ; Packed DPFP absolute value (b)
    vandpd xmm2, xmm1, [rel AbsMaskF64]
    vmovapd [rdx+64], xmm2

    ; Packed DPFP square root (a)
    vsqrtpd xmm2, xmm0
    vmovapd [rdx+80], xmm2

    ; Packed DPFP minimum
    vminpd xmm2, xmm0, xmm1
    vmovapd [rdx+96], xmm2

    ; Packed DPFP maximum
    vmaxpd xmm2, xmm0, xmm1
    vmovapd [rdx+112], xmm2
    ret

section .note.GNU-stack
