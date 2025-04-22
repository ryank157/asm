; extern "C" int64_t IntegerMul_(int8_t a, int16_t b, int32_t c, int64_t d,
; int8_t e,int16_t f, int32_t g, int64_t h)
; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Window BI rcx, rdx, r8 , r9
section .text
     global IntegerMul_
     global UIntegerDiv_

IntegerMul_:
     movsx esi, si ; ext b
     movsx edi, dil ; ext a
     movsx r8, r8b ; ext e
     movsx r9, r9w ; ext f
     imul edi, esi ; a*b
     movsxd rax, [rsp+8] ; ext g imul edi, esi ; a*b
     imul edi, edx ; ab*c
     movsx rdi, edi ; ext abc
     imul rdi, rcx ; abc*d
     imul rdi, r8 ; abcd*e
     imul rdi, r9 ; abcde*f
     imul rax, rdi ; abcdef*g
     imul rax, [rsp+16] ; abcdefgh*h
     ret



; extern "C" int UIntegerDiv_(uint8_t a, uint16_t b, uint32_t c, uint64_t d, uint8_t e,
; uint16_t f, uint32_t g, uint64_t h, uint64_t* quo, uint64_t* rem);

UIntegerDiv_:
     ; Calc a + b + c + d
     movzx rdi, dil
     movzx rsi, si
     mov edx, edx
     mov rax, rcx
     add rax, rdi
     add rax, rsi
     add rax, rdx
     xor rdx, rdx

     ; Calc e + f + g + h
     movzx r8, r8b
     movzx r9, r9w
     add r8, r9
     add r8, [rsp+8]
     add r8, [rsp+16]
     jnz DivOK

     xor rax, rax
     jmp Done

DivOK:
     div r8 ; unsigned div rdx:rax / r8
     mov rcx, [rsp+24]
     mov [rcx], rax ; save quotient
     mov rcx, [rsp+32]
     mov [rcx], rdx
     mov rax, 1



Done:
     ret

     section .note.GNU-stack
