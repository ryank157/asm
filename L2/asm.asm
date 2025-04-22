; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9
section .text
    global CalcArrayValues_

CalcArrayValues_:
    ; long long y* in rdi
    ; int x* in rsi
    ; int a in edx
    ; short b in ecx
    ; int n in r8d
xor rax, rax
xor r10, r10 ; sum
xor r11, r11 ; array index i

cmp r8d, 0
jle InvalidCount ; n <= 0

movsxd rdx, edx
movsxd rcx, ecx
   .CalcLoop:

    movsxd rax, [rsi + r11*4] ; rax = x[i] (sign extended)
    imul rax, rdx ; rax = x[i]*a
    add rax, rcx ; rax = x[i]*a + b

    mov [rdi + r11*8], rax ; y[i] = rax
    add r10, rax ; add to sum
    inc r11 ; increment loop count
    cmp r11d,r8d

    jnz .CalcLoop

; write sum to rax
    mov rax, r10
    ret
InvalidCount:
    xor rax, rax
    ret
section .note.GNU-stack
