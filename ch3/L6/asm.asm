; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

; extern "C" unsigned long long CountChars_(const char* s, char c);
;
; Description:  This function counts the number of occurrences
; of a character in a string.
;
; Returns:      Number of occurrences found.

section .text
    global CountChars_
CountChars_:
xor rdx, rdx
xor r8, r8
    mov rcx, rsi ; cl = c
    mov rsi, rdi ; rsi = s


   .LoopChar:
    lodsb ; load byte into al
    or al,al ; check if null terminator
    jz .Exit ; if null terminator exit
    cmp al, cl ;
    sete r8b ; if al==cl, r8b = 1
    add rdx, r8
    jmp .LoopChar

   .Exit:
    mov rax, rdx
    ret

    ret
section .note.GNU-stack
