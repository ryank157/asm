; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

   %include "cmpequ.asmh"
; extern "C" void AvxPackedCompareF32_(const XmmVal& a, const XmmVal& b, XmmVal c[8]);
; Floating Point
; L/W ABI: xmm0, xmm1,...
section .text
    global AvxPackedCompareF32_
    global AvxPackedCompareF64_

AvxPackedCompareF32_:
    vmovaps xmm0, [rdi] ; xmm0 = a
    vmovaps xmm1, [rsi] ; xmm1 = b

    ; Perform packed EQUAL compare
    vcmpps xmm2,xmm0,xmm1,CMP_EQ
    vmovdqa [rdx],xmm2
    ; Perform packed NOT EQUAL compare
    vcmpps xmm2,xmm0,xmm1,CMP_NEQ
    vmovdqa [rdx+16],xmm2
    ; Perform packed LESS THAN compare
    vcmpps xmm2,xmm0,xmm1,CMP_LT
    vmovdqa [rdx+32],xmm2
    ; Perform packed LESS THAN OR EQUAL compare
    vcmpps xmm2,xmm0,xmm1,CMP_LE
    vmovdqa [rdx+48],xmm2
    ; Perform packed GREATER THAN compare
    vcmpps xmm2,xmm0,xmm1,CMP_GT
    vmovdqa [rdx+64],xmm2
    ; Perform packed GREATER THAN OR EQUAL compare
    vcmpps xmm2,xmm0,xmm1,CMP_GE
    vmovdqa [rdx+80],xmm2
    ; Perform packed ORDERED compare
    vcmpps xmm2,xmm0,xmm1,CMP_ORD
    vmovdqa [rdx+96],xmm2
    ; Perform packed UNORDERED compare
    vcmpps xmm2,xmm0,xmm1,CMP_UNORD
    vmovdqa [rdx+112],xmm2
    ret


    ; extern "C" void AvxPackedCompareF64_(const XmmVal& a, const XmmVal& b, XmmVal c[8]);
AvxPackedCompareF64_:
    vmovapd xmm0,[rdi]                   ; xmm0 = a
    vmovapd xmm1,[rsi]                   ; xmm1 = b
    ; Perform packed EQUAL compare
    vcmppd xmm2,xmm0,xmm1,CMP_EQ
    vmovdqa [rdx],xmm2
    ; Perform packed NOT EQUAL compare
    vcmppd xmm2,xmm0,xmm1,CMP_NEQ
    vmovdqa [rdx+16],xmm2
    ; Perform packed LESS THAN compare
    vcmppd xmm2,xmm0,xmm1,CMP_LT
    vmovdqa [rdx+32],xmm2
    ; Perform packed LESS THAN OR EQUAL compare
    vcmppd xmm2,xmm0,xmm1,CMP_LE
    vmovdqa [rdx+48],xmm2
    ; Perform packed GREATER THAN compare
    vcmppd xmm2,xmm0,xmm1,CMP_GT
    vmovdqa [rdx+64],xmm2
    ; Perform packed GREATER THAN OR EQUAL compare
    vcmppd xmm2,xmm0,xmm1,CMP_GE
    vmovdqa [rdx+80],xmm2
    ; Perform packed ORDERED compare
    vcmppd xmm2,xmm0,xmm1,CMP_ORD
    vmovdqa [rdx+96],xmm2
    ; Perform packed UNORDERED compare
    vcmppd xmm2,xmm0,xmm1,CMP_UNORD
    vmovdqa [rdx+112],xmm2
    ret
section .note.GNU-stack
