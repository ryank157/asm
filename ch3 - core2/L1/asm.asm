; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9
;
; ; extern "C" int CalcArraySum_(const int* x, int n)
;
; Returns:      Sum of elements in array x
section .text
    global CalcArraySum_

CalcArraySum_:
    ; rdi - pointer to array index 0
    ; esi - count of loop
    xor eax, eax

    cmp esi, 0
    jle InvalidCount

   .LAdd:
    add eax, [rdi]
    add rdi, 4
    dec esi
    jnz .LAdd


InvalidCount:
    ret
section .note.GNU-stack
