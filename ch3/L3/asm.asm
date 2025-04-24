; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9
; CalcMatrixSquares_(int *y, const int *x, int nrows,int ncols)
section .text
    global CalcMatrixSquares_

; rdi = int* y
; rsi = int* x
; rdx = int nrows
; rcx = int ncols
CalcMatrixSquares_:
    cmp edx, 0
    jle .InvalidCount ; jump if nrows <= 0
    cmp ecx, 0
    jle .InvalidCount ; jump if ncols <= 0

    movsxd rdx, edx ; rdx = nrows sign extended
    movsxd rcx, ecx ; rcx = ncols sign extended

    xor r8, r8 ; i = 0
    xor r9, r9 ; j = 0

   .RowLoop:
    xor r9, r9 ; j = 0
   .ColLoop:
    mov rax, r9 ; rax = j
    imul rax, rcx ; rax = j * ncols
    add rax, r8 ; rax = j * ncols + i
    mov r10d, [rsi+rax*4]          ; r10d = x[j][i]
    imul r10d, r10d ; r10d = x[j][i]*x[j][i]

    mov rax, r8 ; rax = i
    imul rax, rcx ; rax = i * ncols
    add rax, r9 ; rax = i * ncols + j
    mov [rdi + rax*4], r10d ; y[i][j] = r10d

    inc r9
    cmp r9, rcx ; jump if r9 < rcx
    jl .ColLoop

    inc r8
    cmp r8, rdx ; jump if r8 < rdx
    jl .RowLoop


   .InvalidCount:
    ret
section .note.GNU-stack
