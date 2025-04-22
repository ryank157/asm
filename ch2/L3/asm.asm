; extern "C"  int IntegerShift_(uint a, uint count, uint* a_shl, uint* a_shr);
; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

;Returns: 0 = error (count >=32), 1 = success

section .text
    global IntegerShift_

IntegerShift_:
    xor eax, eax
    cmp esi, 31
    ja InvalidCount ; count greater than type so jump

    mov r11, rcx

    mov ecx, esi ;count to ecx
    mov eax, edi ;a to eax
    shl eax, cl  ; shift a left by count
    mov [rdx], eax ; store result in a_shl

    mov eax, edi ;a back to eax
    shr eax, cl ;shr by count
    mov [r11], eax ; store result in a_shr

    mov eax, 1

InvalidCount:
    ret

section .note.GNU-stack
