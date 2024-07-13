section .text
    global IntegerAddSub_
    global quantum_square_
    global calculate_dimension_
   
IntegerAddSub_:
    ; Calculate a + b + c - d
    mov eax, edi    ; eax = a
    add eax, esi    ; eax = a + b
    add eax, edx    ; eax = a + b + c
    sub eax, ecx    ; eax = a + b + c - d
    ret             ; return result to caller

quantum_square_:
    mov eax, 1      ; Initialize base to 1
    mov ebx, edi    ; Load numQubits into EBX
    mov ecx, eax    ; Store base in ECX (not needed for this specific example, but in case we do repeated multiplication)
    dec ebx         ; Decrement exponent by 1 (since we already have base in EAX)
    jz .done        ; If exponent was 0, we're done

.power_loop:
    imul eax, ecx   ; Multiply EAX by ECX (base)
    dec ebx         ; Decrement exponent counter
    jnz .power_loop ; Repeat until exponent reaches 0

.done:
    ret             ; return result to caller

calculate_dimension_:
    mov eax, 1      ; Initialize the base to 1 (2^0)
    mov ecx, edi    ; Load numQubits into ECX
    shl eax, cl     ; Perform the left shift (1 << numQubits)
    ret             ; return result to caller


