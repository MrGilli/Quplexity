section .text
global IntegerAddSub_
global quantum_square_
global calculate_dimension_
global getMemorySize_
global formatMemorySize_

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

getMemorySize_:
    ; Get the memory size using BIOS interrupt 15h, function E801h
    ; This function returns the memory size in kilobytes
    ; CX:DX - memory size below 16MB in kilobytes
    ; AX:BX - memory size above 16MB in 64KB blocks

    ; Save registers
    push ax
    push bx
    push cx
    push dx
    push di

    ; Call BIOS interrupt 15h, function E801h
    mov ax, 0xE801
    int 0x15
    jc .error          ; If carry flag is set, an error occurred

    ; Calculate total memory size in KB
    ; DX:AX - total memory size in kilobytes
    mov cx, dx         ; Move high word (DX) to CX
    shl ecx, 6         ; Multiply by 64 (shift left by 6)
    add cx, ax         ; Add low word (AX)

    ; Move the result to EAX (return value)
    mov eax, ecx

    jmp .done

.error:
    xor eax, eax       ; If an error occurred, return 0

.done:
    ; Restore registers
    pop di
    pop dx
    pop cx
    pop bx
    pop ax

    ret

formatMemorySize_:
    ; Format memory size in human-readable form (e.g., "2GB" or "16GB")
    ; Assumes memory size is in kilobytes in EAX
    ; Returns result in EAX as the number of gigabytes

    ; Convert kilobytes to gigabytes
    mov ecx, 1048576   ; 1 GB = 1024 * 1024 KB
    xor edx, edx       ; Clear EDX for division
    div ecx            ; EAX = EAX / 1048576 (result in EAX, remainder in EDX)

    ret
