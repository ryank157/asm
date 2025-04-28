; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

; Floating Point
; L/W ABI: xmm0, xmm1,...
;

; extern "C" void CompareVCOMISS_(float a, float b, bool* results);
;
section .text
    global CompareVCOMISS_
    global CompareVCOMISD_

CompareVCOMISS_:
    vcomiss xmm0, xmm1
    setp byte [rdi] ; RFLAGS.PF = 1 if undorded
    jnp FlagStorage
    jmp Unordered


CompareVCOMISD_:
    vcomisd xmm0, xmm1
    setp byte [rdi] ; RFLAGS.PF = 1 if undorded
    jnp FlagStorage

Unordered:
xor al,al
mov byte [rdi+1], al
mov byte [rdi+2], al
mov byte [rdi+3], al
mov byte [rdi+4], al
mov byte [rdi+5], al
mov byte [rdi+6], al
jmp Done
FlagStorage:
    setb byte [rdi +1]
    setbe byte [rdi+2]
    sete byte [rdi+3]
    setne byte [rdi+4]
    seta byte [rdi+5]
    setae byte [rdi+6]


Done:
    ret

; extern "C" void CompareVCOMISD_(double a, double b, bool* results);
section .note.GNU-stack
