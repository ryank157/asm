; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

section .data
struc TestStruct
   .Val64: resq 1 ; qword
   .Val32: resd 1 ; dword
   .Val16: resw 1 ; word
   .Val8:  resb 1 ; byte
   .Pad8:  resb 1 ; byte
endstruc

; extern "C" int64_t CalcTestStructSum_(const TestStruct* ts);
;
; Returns:      Sum of structure's values as a 64-bit integer.

; rdi = *ts

section .text
    global CalcTestStructSum_


CalcTestStructSum_:
movsx eax, byte [rdi + TestStruct.Val8]
movsx esi, word [rdi + TestStruct.Val16]
add eax, esi
movsxd rax, eax
movsxd rsi, dword [rdi + TestStruct.Val32]
add rax, rsi
add rax, qword [rdi + TestStruct.Val64]
ret
    ; movsx eax, byte [rdi + TestStruct.Val8]       ; Load and sign-extend Val8 to eax
    ; movsx esi, word [rdi + TestStruct.Val16]      ; Load and sign-extend Val16 to esi
    ; add eax, esi ; Add Val16 to sum

    ; movsxd rax, eax ; Sign-extend sum to 64 bits

    ; mov esi, dword [rdi + TestStruct.Val32]      ; Load Val32 to esi
    ; movsxd rsi, esi ; Sign-extend Val32 to 64 bits
    ; add rax, rsi ; Add Val32 to sum

    ; add rax, qword [rdi + TestStruct.Val64]      ; Add Val64 to sum
    ; ret
section .note.GNU-stack
