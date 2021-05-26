@ Lab 6
@ main.s

@ define the cpu and fpu
.cpu cortex-a72
.fpu neon-fp-armv8

@ declare strings
.data

.text
.align 2
.global main
.type main, %function

main: 

    @ secure my fp and lr
    push {fp, lr}
    add fp, sp, #4

    bl count_email
    
    @ make sure to return 0
    mov r0, #0
    
    @ restore and close out the file
    sub sp, fp, #4
    pop {fp, pc}
