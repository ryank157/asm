; extern "C" int CalcMatrixRowColSums_(int *row_sums, int *col_sums, const int *x,
; int nrows, int ncols);

; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9
section .text
    global CalcMatrixRowColSums_

CalcMatrixRowColSums_:
    ; rdi = int* row_sums
    ; rsi = int* col_sums
    ; rdx = int* x
    ; rcx = nrows
    ; r8 = ncols
    ; r9 = i
    ; r10 = j
    ; r11 = k
    ; r15 = k + j (before scale factor)
    ; rax = temp


    ; Check if Invalid for rdx, rcx
    cmp rcx, 0
    jle .InvalidDims
    cmp r8, 0
    jle .InvalidDims

    xor r10, r10 ; j = 0
   .LoopColZero:
    ; 0 vals in col_sums
    mov dword [rsi+r10*4], 0 ; col_sums[j] = 0
    inc r10d ; j++
    cmp r10d, r8d
    jl .LoopColZero ; j < ncols
    xor r10, r10 ; j = 0


xor r9, r9 ; i = 0
   .LoopRow:
    ; 0 vals in row_sums
    mov dword [rdi + r9*4], 0 ; row_sums[i] = 0

    ; calc k
    mov r11, r9 ; k = i
    imul r11d, r8d ; k = i * ncols

   .LoopSumCalcPerRow:

    ; calc temp
    mov r15, r11 ; r15 = k
    add r15, r10 ; r15 = k+j
    mov eax, [rdx + r15*4] ; rax = x[k+j]

    add [rdi + r9*4], eax ; row_sums[i] += temp
    add [rsi + r10*4], eax ; col_sums[i] += temp


    inc r10d ; inc j
    cmp r10d, r8d
    jl .LoopSumCalcPerRow ; j < ncols
    xor r10, r10 ; j = 0

    inc r9d ; inc i
    cmp r9d, ecx
    jl .LoopRow


    mov rax, 1
    ret

   .InvalidDims:
    xor rax,rax
    ret
section .note.GNU-stack
