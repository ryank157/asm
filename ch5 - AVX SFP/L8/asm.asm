; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

; Floating Point
; L/W ABI: xmm0, xmm1,..
;
    ; void CalcMatrixSquaresF32_(float* y, const float* x, float offset, int nrows, int ncols);
;
; Calculates:     y[i][j] = x[j][i] * x[j][i] + offset.
;
; rdi = float* y
; rsi = float* x
; xmm0 = float offset
; rdx = nrows
; rcx = ncols
;
; r8d = i
; r9d = j
; rax = kx
; r11d = ky
;
; xmm1 = x calcs
; xmm2 = y[ky]
; write out to y var
section .text
    global CalcMatrixSquaresF32_

CalcMatrixSquaresF32_:
    ; validate nrows, ncols
    cmp rdx, 0
    jle .InvalidCount

    cmp rcx, 0
    jle .InvalidCount

    xor r8d, r8d ; i=0
   .OuterLoop:
    xor r9d, r9d ; j=0
   .InnerLoop:
    ; Calc kx
    mov eax, r9d ; eax = j
    imul eax, ecx ; eax = j*ncols
    add eax, r8d ; eax = j*ncols + i

    ; Calc ky
    mov r11d, r8d ; r11d = i
    imul r11d, ecx ; r11d = i*ncols
    add r11d, r9d ; r11d = i*ncols + j

    ; Load x[kx]
    vmovss xmm1, [rel rsi + 4*rax] ; xmm2 = x[kx]
    vmulss xmm1, xmm1, xmm1 ; xmm1 = x[kx]*x[kx]

    vaddss xmm2, xmm1, xmm0 ; xmm2 = ^ + offset

    vmovss [rel rdi + 4*r11], xmm2

    inc r9d
    cmp r9d, ecx
    jl .InnerLoop

    inc r8d
    cmp r8d, edx
    jl .OuterLoop





   .InvalidCount:
    ret
section .note.GNU-stack
