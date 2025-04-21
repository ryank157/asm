; extern "C" int IntegerAddSub_(int a, int b, int c, int d);

section .text
    global IntegerAddSub_

 IntegerAddSub_: ; Label for the function

       ; 64-bit Linux calling convention (System V AMD64 ABI)
       ; Arguments:
       ;   a in rdi
       ;   b in rsi
       ;   c in rdx
       ;   d in rcx
       ; Return value:
       ;   in rax
       mov eax, edi        ; eax = a (from rdi)
       add eax, esi        ; eax += b (from rsi)
       add eax, edx        ; eax += c (from rdx)
       sub eax, ecx        ; eax -= d (from rcx)
       ret                  ; Return to caller
