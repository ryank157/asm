; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9
section .text
    global SignedMinA_
    global SignedMinB_
    global SignedMaxA_
    global SignedMaxB_

; extern "C" int SignedMinA_(int a, int b, int c);
;
; Returns:      min(a, b, c)

SignedMinA_:
    mov eax, edi
    cmp eax, esi ; compare a & b
    jle .L1 ; jump if a <= b
    mov eax, esi ; eax = b

   .L1:
    cmp eax, edx ; cmp min(a,b) & c
    jle .L2
    mov eax, edx ; eax = min(a,b,c)

   .L2:
    ret
SignedMaxA_:
    mov eax, edi
    cmp eax, esi ; compare a & b
    jge .L1 ; jump if a <= b
    mov eax, esi ; eax = b

   .L1:
    cmp eax, edx ; cmp min(a,b) & c
    jge .L2
    mov eax, edx ; eax = min(a,b,c)

   .L2:
    ret

SignedMinB_:
    cmp edi, esi
    cmovg edi, esi ; if edi > esi, edi = esi or min(edi, esi)
    cmp edi, edx
    cmovg edi, edx
    mov eax, edi
    ret
SignedMaxB_:
    cmp edi, esi
    cmovl edi, esi
    cmp edi, edx
    cmovl edi, edx
    mov eax, edi
    ret


section .note.GNU-stack
