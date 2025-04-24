; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

; Floating Point
; L/W ABI: xmm0, xmm1,...
;
section .data
    qw_PI  dq 3.14159265358979323846
    qw_4p0 dq 4.0
    qw_3p0 dq 3.0
; extern "C" void CalcSphereAreaVolume_(double r, double* sa, double* vol);
section .text
    global CalcSphereAreaVolume_

    ; rdi = double* sa
    ; rsi = double* vol
    ; xmm0[63:0] = r

CalcSphereAreaVolume_:
    ; Calc SA
    ; r*r xmm1
    vmulsd xmm1, xmm0, xmm0 ; xmm1[63:0] = r*r
    vmulsd xmm1, xmm1, [rel qw_PI] ; r*r*PI
    vmulsd xmm1, xmm1, [rel qw_4p0]; r*r*PI*4
    vmovsd qword [rdi], xmm1

    ; Calc V
    ; Cube xmm0
    vmulsd xmm2, xmm1, xmm0 ; xmm2[63:0] = (r*r*PI*4)*r
    vdivsd xmm2, xmm2, [rel qw_3p0] ; xmm2[63:0] = (rrrPI4)/3
    vmovsd qword [rsi], xmm2
    ; movssd to [rsi]


    ret
section .note.GNU-stack
