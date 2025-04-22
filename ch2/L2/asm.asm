; extern "C" unsinged int IntegerLogical_(uint a, uint b, uint c, uint d)
extern g_Val1

section .text
    global IntegerLogical_

IntegerLogical_:
    ; Calc (((a & b) | c) & d)
    mov eax, edi
    and eax, esi
    or eax, edx
    xor eax, ecx
    mov r10d, dword [rel g_Val1]  ; Use RIP-relative addressing with 'rel'
    add eax, r10d
    ret

section .note.GNU-stack
