section .text
    global IntegerAddSub_

IntegerAddSub_:
    ; Calculate a + b + c - d
    mov eax, edi    ; eax = a
    add eax, esi    ; eax = a + b
    add eax, edx    ; eax = a + b + c
    sub eax, ecx    ; eax = a + b + c - d
    ret             ; return result to caller
