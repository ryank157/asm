; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

; Floating Point
; L/W ABI: xmm0, xmm1,...
;
; extern "C" void CompareVCMPSD_(double a, double b, bool* results)
   %include "asmh.asmh"
section .text
    global CompareVCMPSD_

CompareVCMPSD_:
    vcmpsd xmm2, xmm0, xmm1, CMP_EQ
    vmovq rax, xmm2
    and al,1
    mov byte [rdi], al

    ; Perform compare for inequality
    vcmpsd xmm2,xmm0,xmm1,CMP_NEQ
    vmovq rax,xmm2
    and al,1
    mov byte [rdi+1],al
    ; Perform compare for less than
    vcmpsd xmm2,xmm0,xmm1,CMP_LT
    vmovq rax,xmm2
    and al,1
    mov byte [rdi+2],al
    ; Perform compare for less than or equal
    vcmpsd xmm2,xmm0,xmm1,CMP_LE
    vmovq rax,xmm2
    and al,1
    mov byte [rdi+3],al
    ; Perform compare for greater than
    vcmpsd xmm2,xmm0,xmm1,CMP_GT
    vmovq rax,xmm2
    and al,1
    mov byte [rdi+4],al
    ; Perform compare for greater than or equal
    vcmpsd xmm2,xmm0,xmm1,CMP_GE
    vmovq rax,xmm2
    and al,1
    mov byte [rdi+5],al
    ; Perform compare for ordered
    vcmpsd xmm2,xmm0,xmm1,CMP_ORD
    vmovq rax,xmm2
    and al,1
    mov byte [rdi+6],al
    ; Perform compare for unordered
    vcmpsd xmm2,xmm0,xmm1,CMP_UNORD
    vmovq rax,xmm2
    and al,1
    mov byte [rdi+7],al

    ret
section .note.GNU-stack
