; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

; Floating Point
; L/W ABI: xmm0, xmm1,...

; extern "C" bool AvxPackedConvertFP_(const XmmVal& a, XmmVal& b, CvtOp cvt_op);
section .text
    global AvxPackedConvertFP_

AvxPackedConvertFP_:
    cmp rdx, CvtOpTableCount
    jae InvalidCvtOp

    mov eax, 1
    lea r8, [rel CvtOpTable]
    jmp [r8 +rdx*8]

I32_F32:
    vmovdqa xmm0, [rdi]
    vcvtdq2ps xmm1, xmm0
    vmovaps [rsi], xmm1
    ret
F32_I32:
    vmovaps xmm0, [rdi]
    vcvtps2dq xmm1, xmm0
    vmovdqa [rsi], xmm1
    ret
I32_F64:
    vmovdqa xmm0, [rdi]
    vcvtdq2pd xmm1, xmm0
    vmovapd [rsi], xmm1
    ret
F64_I32:
    vmovapd xmm0, [rdi]
    vcvtpd2dq xmm1, xmm0
    vmovdqa [rsi], xmm1
    ret
F32_F64:
    vmovaps xmm0, [rdi]
    vcvtps2pd xmm1, xmm0
    vmovapd [rsi], xmm1
    ret
F64_F32:
    vmovapd xmm0, [rdi]
    vcvtpd2ps xmm1, xmm0
    vmovapd [rsi], xmm1
    ret


InvalidCvtOp:
    xor eax, eax
    ret

section .data
CvtOpTable:
align 8
    dq I32_F32, F32_I32
    dq I32_F64, F64_I32
    dq F32_F64, F64_F32
    CvtOpTableCount equ ($ - CvtOpTable) / 8
section .note.GNU-stack
