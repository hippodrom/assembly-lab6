@ Lab 6
@ read_email.s

@ define the cpu and fpu
.cpu cortex-a72
.fpu neon-fp-armv8

@ declare strings
.data
stringChar: .asciz "%s"
stringNewlineChar: .asciz "%s\n"
rText: .asciz "r"
    
.text
.align 2
.global count_email
.type count_email, %function

count_email: 

    @ secure my fp and lr
    push {fp, lr}
    add fp, sp, #4

    @ r0 contains *sp of email name
    push {r0} @ email name at [fp, #-8]
    
    @ open for reading
    ldr r0, [fp, #-8]
    ldr r1, =rText
    bl fopen

    push {r0}          @ email file pointer at [fp, #-12]
    
    
    @ char[80] for string buffer at [fp, #-16]
    mov r0, #80
    bl malloc

    push {r0}
    
    @ skip the first(subject) line
    @ fgets(*str, 80, *fp)
    ldr r0, [fp, #-16]       
    mov r1, #80
    ldr r2, [fp, #-12]

    bl fgets
    
    @ get the next word using fscanf
    @ fscanf (fp, "%s", sp)
    ldr r0, [fp, #-12]
    ldr r1, =stringChar
    ldr r2, [fp, #-16]

    bl fscanf


body_loop:
    
    cmp r0, #1
    bne done
        
    @ write to dictionary.txt if unique
    ldr r0, [fp, #-16]

    @ match returns a 1 if not unique, so count
    @ #-999 = word is unique skip
    bl match
    cmp r0, #-999
    beq next_word
    
    ldr r0, [fp, #-16]
    @ bl write_to_index

next_word:  
    
    @ get the next word using fscanf
    @ fscanf (fp, "%s", sp)
    ldr r0, [fp, #-12]
    ldr r1, =stringChar
    ldr r2, [fp, #-16]

    bl fscanf

    b body_loop
	
done:
    
    @ close email
    ldr r0, [fp, #-12]
    bl fclose

    @ free malloc
    ldr r0, [fp, #-16]
    bl free

    @ restore and close out the file
    sub sp, fp, #4
    pop {fp, pc}
