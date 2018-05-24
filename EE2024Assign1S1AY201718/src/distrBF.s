 	.syntax unified
 	.cpu cortex-m3
 	.thumb
 	.align 2
 	.global	distrBF
 	.thumb_func

@ EE2024 Assignment 1, Sem 1, AY 2017/18
@ (c) CK Tham, ECE NUS, 2017
// Yang Hanfu Michael A0155097X
// Yeo Wen Jie A0162193H

distrBF:
	PUSH {R14, R4, R5, R6, R7, R8, R9, R10, R11, R12}
	LDR R4, [R3] //value of N is in R4, value of T is in R0
	MOV R7, #1 //R7 be t (row)
	MOV R8, #1 //R8 be n (column)
	MOV R12, #1 //initialise smallest n when n = 1

loop:
	MOV R6, R1 //R6 hold address of Dij
	BL RETRIEVE //gets Dij
	MOV R10, R9 //moves Dij value to R10
	MOV R6, R2 //R6 hold address of Dj
	BL RETRIEVE //gets Dj in R9
	ADD R6, R9, R10 //R6 contains sum of Dij and Dj

	CMP R8, #1 // initialise smallest n value when n = 1
	IT EQ
	MOVEQ R11, R6

	//comparing and replacing if need
	CMP R11, R6
	ITT PL
	MOVPL R11, R6 //keep the smallest sum
	MOVPL R12, R8 //keep the smallest n

	CMP R8, R4 //compare n with N
	ADD R8, R8, #1
	BNE loop

	MOV R8, #8
	MUL R8, R8, R7
	SUB R8, R8, #8

	STR R11, [R3, R8]
	ADD R8, R8, #4
	STR R12, [R3, R8]

	MOV R8, #1 //resets n
	ADD R7, R7, #1 //increment t by 1

	CMP R7, R0 //compares t with T
	BLS loop

	POP {R14, R4, R5, R6, R7, R8, R9, R10, R11, R12}
	BX LR

@ Subroutine RETRIEVE
RETRIEVE: //retrive Dij/DJ based on R7(t), R8(n), R6(add of Dij/DJ) and puts value in R9
	MLA R5, R4, R7, R8
	SUB R5, R5, R4
	SUB R5, R5, #1
	ADD R5, R5, R5
	ADD R5, R5, R5	//amount of offset from first value of address
	LDR R9, [R6, R5] //R6 contains Dij/DJ value we are looking at now
	BX LR

	NOP
	.end
