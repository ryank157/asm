; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9
;

; extern "C" long long CompareArrays_(const int* x, const int* y, long long n)
;
; Returns -1
; Value of 'n' is invalid
; 0 <= i < n Index of first non-matching element
; n All elements match
section .text
    global CompareArrays_

CompareArrays_:

    mov rcx, rdx
    mov rax, -1
    test rcx, rcx
    jle .InvalidLength


    mov rax, rcx ; rax = n
    repe cmpsd
    je .Match

    ; Calc index of first non-match
    sub rax, rcx
    dec rax

   .InvalidLength:
   .Match:
    ret
section .note.GNU-stack
