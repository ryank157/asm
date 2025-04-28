; Linux ABI rdi, rsi, rdx, rcx, r8, and r9
; Windows ABI rcx, rdx, r8, and r9

; Floating Point
; L/W ABI: xmm0, xmm1,...
;
MxcsrRcMask equ 9fffh ; bit pattern for MXCSR.RC
MxcsrRcShift equ 13 ; shift count for MXCSR.RC
; extern "C" RoundingMode GetMxcsrRoundingMode_(void);

section .text
    global GetMxcsrRoundingMode_
    global SetMxcsrRoundingMode_
    global ConvertScalar_


GetMxcsrRoundingMode_:
    sub rsp, 16

    vstmxcsr [rsp]
    mov eax, [rsp]
    shr eax, MxcsrRcShift
    and eax, 11b
    add rsp, 16
    ret

    ; extern "C" void SetMxcsrRoundingMode_(RoundingMode rm);
    ;
    ; Description:  The following function updates the rounding mode
    ; value in MXCSR.RC.
SetMxcsrRoundingMode_:
    sub rsp, 16

    and edi, 3
    shl edi, MxcsrRcShift
    vstmxcsr [rsp]
    mov eax, [rsp]
    and eax, MxcsrRcMask
    or eax, edi
    mov [rsp], eax
    vldmxcsr [rsp]

    add rsp, 16


    ret

    ; extern "C" bool ConvertScalar_(Uval* des, const Uval* src, CvtOp cvt_op)
    ;
    ; Note:         This function requires linker option /LARGEADDRESSAWARE:NO
    ; to be explicitly set.
    ; extern "C" bool ConvertScalar_(Uval* des, const Uval* src, CvtOp cvt_op)
    ; RDI = des, RSI = src, EDX = cvt_op
ConvertScalar_:
    mov eax, edx ; eax = CvtOp
    cmp eax, CvtOpTableCount
    jae BadCvtOp ; jump if cvt_op is invalid
    lea rcx, [rel CvtOpTable]
    mov rax, [rcx + rax*8]
    jmp rax ; jump to specified conversion

    ; Conversions between int32_t and float/double
I32_F32:
    mov eax, [rsi]              ; load integer value
    vcvtsi2ss xmm0, xmm0, eax ; convert to float
    vmovss [rdi], xmm0 ; save result
    mov eax, 1 ; return true
    ret

F32_I32:
    vmovss xmm0, [rsi]          ; load float value
    vcvtss2si eax, xmm0 ; convert to integer
    mov [rdi], eax ; save result
    mov eax, 1
    ret

I32_F64:
    mov eax, [rsi]              ; load integer value
    vcvtsi2sd xmm0, xmm0, eax ; convert to double
    vmovsd [rdi], xmm0 ; save result
    mov eax, 1
    ret

F64_I32:
    vmovsd xmm0, [rsi]          ; load double value
    vcvtsd2si eax, xmm0 ; convert to integer
    mov [rdi], eax ; save result
    mov eax, 1
    ret

    ; Conversions between int64_t and float/double
I64_F32:
    mov rax, [rsi]              ; load integer value
    vcvtsi2ss xmm0, xmm0, rax ; convert to float
    vmovss [rdi], xmm0 ; save result
    mov eax, 1
    ret

F32_I64:
    vmovss xmm0, [rsi]          ; load float value
    vcvtss2si rax, xmm0 ; convert to integer
    mov [rdi], rax ; save result
    mov eax, 1
    ret

I64_F64:
    mov rax, [rsi]              ; load integer value
    vcvtsi2sd xmm0, xmm0, rax ; convert to double
    vmovsd [rdi], xmm0 ; save result
    mov eax, 1
    ret

F64_I64:
    vmovsd xmm0, [rsi]          ; load double value
    vcvtsd2si rax, xmm0 ; convert to integer
    mov [rdi], rax ; save result
    mov eax, 1
    ret

    ; Conversions between float and double
F32_F64:
    vmovss xmm0, [rsi]          ; load float value
    vcvtss2sd xmm1, xmm1, xmm0 ; convert to double
    vmovsd [rdi], xmm1 ; save result
    mov eax, 1
    ret

F64_F32:
    vmovsd xmm0, [rsi]          ; load double value
    vcvtsd2ss xmm1, xmm1, xmm0 ; convert to float
    vmovss [rdi], xmm1 ; save result
    mov eax, 1
    ret

BadCvtOp:
    xor eax, eax ; set error return code (false)
    ret

    section .data
    align 8
CvtOpTable:
    dq I32_F32, F32_I32
    dq I32_F64, F64_I32
    dq I64_F32, F32_I64
    dq I64_F64, F64_I64
    dq F32_F64, F64_F32
    CvtOpTableCount equ ($ - CvtOpTable) / 8

    section .note.GNU-stack
