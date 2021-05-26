@
@ match.s
@ Author: Omar El Naggar
@
.cpu cortex-a53
.fpu neon-fp-armv8
.syntax unified         @ modern syntax

.data
filename: .asciz	 "dictionary.txt"    @ char filename[] = "dictionary.txt";
read: .asciz   "r"
scanString: .asciz "%s"

.text
.align 2
.global match
.type match, %function

match: 
  push	{r4, r5, r6, fp, lr}   @ start program
  add fp, sp, #4

  mov r6, #0  @ r6 holds index

  push {r0}   @ incoming string

  mov  r0, #60
  bl malloc
  push {r0}   @ test string

  @ FILE *dict = fopen(filename, "r");
  ldr   r1, =read       @ loads read address to second arg
  ldr   r0, =filename   @ loads new file address to first arg
	bl	  fopen
	mov	  r5, r0          @ saves fp to r5

whileLoop: @ while ()
  mov   r0, r5
	ldr	  r1, =scanString   @ chars to read = #60 -> r1
	ldr 	r2, [fp, #-12]	  @ string addr
	bl	  fscanf      		  @ fscanf(fp, "%s", str1); != NULL
	cmp   r0, #-1           @ compare current string with previous string
	beq   returnZero

	ldr r0, [fp, #-12]
  ldr r1, [fp, #-8]
  bl strcmp							@ if (strcmp(string1, string2) == 0)
	cmp r0, #0
  beq returnOne

  add r6, #1

  b whileLoop

close:
	mov 	r0, r5
	bl  	fclose      @ fclose(dict)

  ldr r0, [fp, #-12]
  bl free

end:
  mov r0, r4  @ return index
  sub sp, fp, #4
  pop	{r4, r5, r6, fp, pc}

returnZero:
	mov r4, #-999   @ else return 0
  b close

returnOne:
	mov r4, r6   @ return 1
  b close
