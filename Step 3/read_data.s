@ Lab 6
@ make_dictionary.s

@ define the cpu and fpu
.cpu cortex-a72
.fpu neon-fp-armv8

@ declare strings
.data
dataFile: .asciz "data.txt"
stringOutput: .asciz "%s"
newlineChar: .asciz "\n"
rText: .asciz "r"
    
.text
.align 2
.global read_data
.type read_data, %function

read_data: 

    @ secure my fp and lr
    push {fp, lr}
    add fp, sp, #4

    @ open data.txt for reading
    ldr r0, =dataFile
    ldr r1, =rText
    bl fopen   

    push {r0}             @ data.txt fp at [fp, #-8]
    
    @ char[80] stringBuffer for email names
    mov r0, #80
    bl malloc

    push {r0}             @ stringBuffer at [fp, #-12]

    
    mov r10, #0           @ i = 0
    mov r9, #250
    mov r9, r9, LSL #4    @ 4000 emails    

loop:

    cmp r10, r9
    bge done

    @ fgets(*str, 80, *fp)
    ldr r0, [fp, #-12]
    mov r1, #80
    ldr r2, [fp, #-8]

    bl fgets

    @ get rid of "\n" token at end of email name
    ldr r0, [fp, #-12]
    ldr r1, =newlineChar

    bl strtok

    @ file name is in [fp, #-12]
    ldr r0, [fp, #-12]
    
    @ read email into dictionary.txt
    bl count_email
    
    add r10, r10, #1
    b loop
    
done:	

    @ close data.txt
    ldr r0, [fp, #-8]
    bl fclose

    @ free malloc
    ldr r0, [fp, #-12]
    bl free
    
    
    @ restore and close out the file
    sub sp, fp, #4
    pop {fp, pc}
