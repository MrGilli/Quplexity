; © Jacob Liam Gill 2025. All rights reserved. **DO NOT REMOVE THIS LINE.**
; Quplexity MUST be credited in the project you use it in either throughout documentation and/or in the code base. **DO NOT REMOVE THIS LINE.**

; I'm striving to make the code for Quplexity as readable as possible.
; If you would like to contribute or contact me for any other reason please don't hesitate to email me: jacobygill@outlook.com
; Or DM/friend request me on Discord: @mrgill0651

section .data
    one dd 1.0
    results dq 0.0, 0.0, 0.0, 0.0           ; To store the result of the division
    mA dq 0.0
    mB dq 0.0

section .text
    global sqrt_array_asm
    global floatingpoint_sqrt
    extern exp
    extern log
    extern sqrt
    global sqrt_exponential_log_asm
    global gills_matrix1x2
    global matrix2x2
    global gills_inv_matrix2x2
    global return_0

sqrt_exponential_log_asm:
    ; Arguments:
    ; xmm0: Input float number

    ; Compute log(x)
    call log                ; Call the log function
    ; Compute exp(log(x)) which is just x
    call exp                ; Call the exp function
    ; Compute sqrt(exp(log(x)))
    sqrtss xmm0, xmm0      ; Compute the square root
    ret

sqrt_array_asm:
    ; Arguments:
    ; rdi: Pointer to input array
    ; rsi: Pointer to output array
    ; rdx: Number of elements in the array

    ; Initialize pointers
    mov     rcx, rdx         ; rcx = number of elements
    cmp     rcx, 0           ; Check if number of elements is zero
    je      done            ; If zero, we're done

.loop:
    ; Load 4 floats from input array into xmm0
    movaps  xmm0, [rdi]
    ; Compute the square root
    sqrtps  xmm0, xmm0
    ; Store the result into the output array
    movaps  [rsi], xmm0
    ; Increment pointers
    add     rdi, 16          ; Move to the next 4 floats
    add     rsi, 16
    ; Decrement the counter
    sub     rcx, 4
    jg      .loop

done:
    ret

floatingpoint_sqrt:
    ; Arguments:
    ; xmm0: Input float number
    ; Return value in xmm0

    ; Compute the square root
    sqrtss xmm0, xmm0
    ; Return the result in xmm0
    ret

gills_matrix1x2:
    ; Multiply two 1 by 2 matrix:
    ; |x| * |y|
    ; |y|   |x|

    ; Load values
    ; Load integers into registers
    movss xmm1, dword [rdi]     ; xmm1 = num1
    movss xmm2, dword [rsi]     ; xmm2 = num2
    movss xmm3, dword [rdx]     ; xmm3 = num3
    movss xmm4, dword [rcx]     ; xmm4 = num4

    ; Perform matrix multiplication
    mulss xmm1, xmm3            ; rax = num1 * num3
    mulss xmm2, xmm4            ; rcx = num2 * num4

    addss xmm1, xmm2            ; rax = rax + rbx

    movss xmm0, xmm1            ; move answer into xmm0 for output.

    ; Store the result in the output matrix
    ;mov qword [rdi], rax       ; First element
    ;mov qword [rdi + 8], rcx   ; Second element

    ret                         ; return to caller

matrix2x2:
    ; Arguments:
    ; rdi: Pointer to matrix A (2x2)
    ; rsi: Pointer to matrix B (2x2)
    ; rdx: Pointer to result matrix C (2x2)

    ; Calculate C[0][0]
    mov rax, [rdi]        ; A[0][0]
    mov rbx, [rdi + 8]    ; A[0][1]
    mov rcx, [rsi]        ; B[0][0]
    mov r8, [rsi + 16]    ; B[1][0]
    imul rax, rcx         ; A[0][0] * B[0][0]
    imul rbx, r8          ; A[0][1] * B[1][0]
    add rax, rbx          ; (A[0][0] * B[0][0]) + (A[0][1] * B[1][0])
    mov [rdx], rax        ; Store result in C[0][0]

    ; Calculate C[0][1]
    mov rax, [rdi]        ; A[0][0]
    mov rbx, [rdi + 8]    ; A[0][1]
    mov rcx, [rsi + 8]    ; B[0][1]
    mov r8, [rsi + 24]    ; B[1][1]
    imul rax, rcx         ; A[0][0] * B[0][1]
    imul rbx, r8          ; A[0][1] * B[1][1]
    add rax, rbx          ; (A[0][0] * B[0][1]) + (A[0][1] * B[1][1])
    mov [rdx + 8], rax    ; Store result in C[0][1]

    ; Calculate C[1][0]
    mov rax, [rdi + 16]   ; A[1][0]
    mov rbx, [rdi + 24]   ; A[1][1]
    mov rcx, [rsi]        ; B[0][0]
    mov r8, [rsi + 16]    ; B[1][0]
    imul rax, rcx         ; A[1][0] * B[0][0]
    imul rbx, r8          ; A[1][1] * B[1][0]
    add rax, rbx          ; (A[1][0] * B[0][0]) + (A[1][1] * B[1][0])
    mov [rdx + 16], rax   ; Store result in C[1][0]

    ; Calculate C[1][1]
    mov rax, [rdi + 16]   ; A[1][0]
    mov rbx, [rdi + 24]   ; A[1][1]
    mov rcx, [rsi + 8]    ; B[0][1]
    mov r8, [rsi + 24]    ; B[1][1]
    imul rax, rcx         ; A[1][0] * B[0][1]
    imul rbx, r8          ; A[1][1] * B[1][1]
    add rax, rbx          ; (A[1][0] * B[0][1]) + (A[1][1] * B[1][1])
    mov [rdx + 24], rax   ; Store result in C[1][1]

    ret

gills_inv_matrix2x2:

    movss xmm1, dword [rdi]     ; xmm1 = num1
    movss xmm2, dword [rsi]     ; xmm2 = num2
    movss xmm3, dword [rdx]     ; xmm3 = num3
    movss xmm4, dword [rcx]     ; xmm4 = num4
    
    ; Calculate determinant: det(A)
    ; det(A) = ad - dc

    movss [mA], xmm1            ; load the current value of xmm1 into float [mA] in memory
    movss [mB], xmm2            ; load the current value of xmm2 into float [mB] in memory

    mulss xmm1, xmm4            ; xmm1 = ad
    mulss xmm2, xmm3            ; xmm2 = dc

    subss xmm1, xmm2            ; xmm1 = ad - dc
    pxor xmm8, xmm8             ; load zero into xmm8
    ucomiss xmm1, xmm8          ; compare the resultant of ad - dc with zero

    jp determinant_error        ; if ad - dc = 0 there is no inverse of the matrix

    ;ELSE CONTINUE 

    movss xmm5, [one]           ; xmm5 = 1.0
    movss xmm6, [mA]            ; get the [mA] value ready for use
    movss xmm7, [mB]            ; get the [mB] value ready for use

    divss xmm5, xmm1            ; xmm5 = 1/det(A)
                                ; xmm5 now holds the value of det(A)

    ; Compute the inverse matrix elements
    movss xmm6, [mA]            ; Load mA value into xmm6
    mulss xmm6, xmm5            ; xmm6 = num1 * (1 / det(A))
    movss xmm7, [mB]            ; Load mB value into xmm7
    mulss xmm7, xmm5            ; xmm7 = num2 * (1 / det(A))

    mulss xmm3, xmm5            ; xmm3 = num3 * (1 / det(A))
    mulss xmm4, xmm5            ; xmm4 = num4 * (1 / det(A))

    ; Store results in inv_matrix_C
    movss dword [r8], xmm6      ; Store xmm6 in inv_matrix_C[0]
    movss dword [r8 + 4], xmm7  ; Store xmm7 in inv_matrix_C[1]
    movss dword [r8 + 8], xmm3  ; Store xmm3 in inv_matrix_C[2]
    movss dword [r8 + 12], xmm4 ; Store xmm4 in inv_matrix_C[3]

          
    ret

determinant_error:
    mov rax, 0
    ret

return_0:
    ret
