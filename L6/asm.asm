; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9
section .rodata
FibVals dd 0, 1, 1, 2, 3, 5, 8, 13, 21,
     dd 34, 55, 89, 144, 233, 377, 610, 987, 1597

NumFibVals_ dd ($-FibVals)/ 4
     global NumFibVals_


; Data section (data is read/write)
section .bss
FibValsSum_ resd 1 ; value to demo RIP-relative addressing
     global FibValsSum_

     ;
     ; extern "C" int MemoryAddressing_(int i, int* v1, int* v2, int* v3, int* v4);
     ;
     ; Returns:      0 = error (invalid table index), 1 = success
     ;

section .text
     global MemoryAddressing_

; i is in rdi for Linux ABI
; v1 is in rsi
; v2 is in rdx
; v3 is in rcx
; v4 is in r8 (if needed, was r9 in Windows)
MemoryAddressing_:

; i is valid
     cmp edi, 0
     jl InvalidIndex
     cmp edi, [rel NumFibVals_]
     jge InvalidIndex
; Sign extend i
     movsxd rdi, edi
     mov r10, rdi
; Ex 1 - base Reg
     lea r11, [rel FibVals] ; r11 points to Fibvals mem loc
     shl r10, 2
     add r11, r10
     mov eax, [r11]
     mov [rsi], eax

; Ex 2 - Base + Index reg

     lea r11, [rel FibVals]
     mov r10, rdi
     shl r10, 2
     mov eax, [r11+r10]
     mov [rdx], eax

; Ex 3 - Base + Index * Scale
     lea r11, [rel FibVals]
     mov r10, rdi
     mov eax, [r11 + 4*r10]
     mov [rcx], eax

; Ex 4 - base + index*scale + disp
     lea r11, [rel FibVals-42]
     mov r10, rdi
     mov eax, [r11 + r10*4 +42]
     mov [r8], eax

; RIP rel
     add [rel FibValsSum_], eax

     mov eax, 1
     ret

InvalidIndex:
     xor eax, eax
     ret
section .note.GNU-stack
