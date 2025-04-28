; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

; Floating Point
; L/W ABI: xmm0, xmm1,...

; extern "C" bool CalcMeanStdev(double* mean, double* stdev, const double* a, int n);
;
; Returns:      0 = invalid n, 1 = valid n
section .text
    global CalcMeanStdev_

CalcMeanStdev_:
    ; check if n is valid, n >1

    cmp ecx, 1
    jle InvalidAmount

; CalcMean

    ; rdi =  double* mean result
    ; rsi = double* stdev result
    ; rdx = double* a
    ; rcx = n
    xor rax, rax ; i = 0
    vxorpd xmm0, xmm0, xmm0 ; xmm0 = 0.0
   .SumXi:
    vaddsd xmm0,xmm0, [rdx + rax*8]
    inc rax
    cmp rcx, rax
    jg .SumXi
    ; xmm0 = Sum x

    ; Divide by n and save result
    vcvtsi2sd xmm1, xmm1, rcx ; xmm3 = double n
    vdivsd xmm0, xmm0, xmm1 ; xmm3 = Sum(x)/n
    vmovsd [rdi], xmm0 ; x_avg

    ; xmm3 = temp sub val
    ; xmm2 = sum of squares
    ; xmm1 = double n
    ; xmm0 = x_avg
    ; rcx = i
    ; Compute stdev
    xor rax, rax ; i = 0
    vxorpd xmm2, xmm2, xmm2 ; xmm2 = 0.0
   .CalcVariance:
    vmovsd xmm3, [rdx + rax*8] ; xmm3 = x[i]
    vsubsd xmm3, xmm3, xmm0 ; xmm3 = x[i] - x_avg
    vmulsd xmm3, xmm3, xmm3 ; xmm3 = (x[i] - x_avg)^2
    vaddsd xmm2, xmm2, xmm3 ; xmm2 = sum of ^
    inc rax
    cmp rcx, rax
    jg .CalcVariance

    ; xmm2 = Sum of squares (x[i] - x_avg)
    sub rcx, 1 ; rdx = n-1
    vcvtsi2sd xmm1, xmm1, rcx
    vdivsd xmm0, xmm2, xmm1 ; xmm0 = 1/(n-1) * sum of squares
    vsqrtsd xmm0, xmm0, xmm0
    vmovsd [rsi], xmm0

    mov eax, 1
    ret




InvalidAmount:
    xor rax, rax
    ret
section .note.GNU-stack
