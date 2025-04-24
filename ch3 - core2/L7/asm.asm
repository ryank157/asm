; ConcatStrings_ implementation for Linux x86-64
; Equivalent to the Windows MASM version
;
; C function prototype:
; extern "C" size_t ConcatStrings_(char* des, size_t des_size, const char* const* src, size_t src_n);
;
; Parameters:
; rdi = des (first parameter)
; rsi = des_size (second parameter)
; rdx = src (third parameter)
; rcx = src_n (fourth parameter)
;
; Returns:
; rax = -1 Invalid 'des_size'
; rax >= 0 Length of concatenated string
;
; Important regs for repne scasb
; rcx - tracking length starting from -1
; rdi - destination pointer
; rsi - source pointer
; rax return number

section .text
    global ConcatStrings_

ConcatStrings_:
    push rbx

    mov rbx, rdi ; rbx, rdi = des
    mov r8, rdx ; r8 = src
    mov rdx, rsi ; rdx = des_size
    mov r9, rcx ; r9 = src_n
    mov rsi, r8 ; rsi = source

    ; test src_n and des_size
    mov rax, -1
    test rdx,rdx
    jz .InvalidArg
    test r9, r9
    jz .InvalidArg

    ; Setup the Loop
    ; rbx = des
    ; rdx = des_size
    ; r8 = src
    ; r9 = src_n
    ; r10 = des_index
    ; r11 = i
    ; rcx = str length
    ; rsi,rdi = pointers for scasb & movsb

    xor r10, r10 ; des_index = 0
    xor r11, r11 ; i = 0
    mov byte [rbx], 0 ; *des = '\0'

   .LoopCopy:

    ; Position rdi, rsi properly
    mov rax, r8 ; rax = src
    mov rdi, [rax + r11*8] ; rdi = src[i] (needed for scasb)
    mov rsi, rdi ; Not needed/used now, but used later in movsb

    ; Compute length of src[i] using rdi
    xor eax, eax
    mov rcx, -1 ; rcx = max
    repne scasb ; scan rdi until find '\0'. inc rcx, rdi per check
    not rcx
    dec rcx ; rcx = len(src[i])

    ; Comput des_index + src_len
    mov rax, r10 ; rax = des_index
    add rax, rcx ; rax = des_index + len(src[i])
    cmp rax, rdx
    jge .Done ; if rax >= rdx, jump. This handles null terminator addition

    ; Update des_index
    mov rax, r10 ; rax = des_index_old
    add r10, rcx ; des_index += len(src[i])

    ; Copy src[i] to &des[des_index]
    inc rcx ; rcx = len(src[i]) + 1 (include '\0')
    lea rdi, [rbx + rax] ; rdi = &des[i] (reset this back to what rsi was earlier
    rep movsb

    ; Update i and rep if not done
    inc r11 ; i++
    cmp r11,r9
    jl .LoopCopy

    ; Done
   .Done:
    mov rax, r10


   .InvalidArg:
    pop rbx
    ret
section .note.GNU-stack
