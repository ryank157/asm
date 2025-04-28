; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9
;
section .data
    dd_ScaleFtoC   dd 0.55555556 ; 5 / 9
    dd_ScaleCtoF   dd 1.8 ; 9 / 5
    dd_32p0 dd 32.0
; extern "C" float ConvertFtoC_(float deg_f)
;
; Returns: xmm0[31:0] = temperature in Celsius.
section .text
    global ConvertFtoC_
    global ConvertCtoF_

    ; xmm0[31:0] = F
ConvertFtoC_:
    vsubss xmm0, xmm0, [rel dd_32p0] ; xmm2[31:0] = F - 32
    vmulss xmm0, xmm0, [rel dd_ScaleFtoC] ; xmm0[31:0] = (F-32)*(5/9)
    ret

ConvertCtoF_:
    vmulss xmm0, xmm0, [rel dd_ScaleCtoF] ; xmm0[31:0] = 1.8C
    vaddss xmm0, xmm0, [rel dd_32p0] ; xmm0[31:0] = 1.8C + 32
    ret

section .note.GNU-stack
