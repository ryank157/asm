; extern "C" unsinged int IntegerMulDiv_(int a, int b, int* prod, int* quo, int* rem)
; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

; Returns 0 if error, 1 if success
section .text
    global IntegerMulDiv_

IntegerMulDiv_:
    mov r10, rdx
    mov eax, esi
    or eax, eax
    jz InvalidDivisor

    ;Calc prod and save
    imul eax, edi
    mov [r10], eax

    ; Calc quot/rem and save
    mov r11d, esi
    mov eax, edi
    cdq
    idiv r11d

    mov [rcx], eax
    mov [r8],edx
    mov eax,1
    ret

InvalidDivisor:
    xor eax, eax
    ret
section .note.GNU-stack
