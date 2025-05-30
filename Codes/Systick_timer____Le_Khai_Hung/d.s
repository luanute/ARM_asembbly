
RCC_BASE                EQU  0x40021000
RCC_APB2ENR_OFFSET 	    EQU  0x18
RCC_APB2ENR             EQU  RCC_BASE + RCC_APB2ENR_OFFSET	



STK_CTRL                EQU 0xE000E010	
STK_LOAD                EQU 0xE000E014 
STK_VAL                 EQU 0xE000E018


            AREA GPIO, CODE, READONLY
		    ENTRY
		    EXPORT __main
			EXPORT SysTick_Handler
			   
__main
			LDR R0, =RCC_APB2ENR
			LDR R1, =0xFC
			STR R1, [R0]
			
			LDR R1, =0x33333333
			LDR R0, =0x40010800
			STR R1, [R0]
			
			LDR R1, =0x33333333
			LDR R0, =0x40010804
			STR R1, [R0]
			BL SYSTICK
LOOP     	B  LOOP
		
SYSTICK
	LDR R0, =STK_LOAD
	LDR R1, =719999999
	STR R1, [R0]
	
	LDR R0, =STK_CTRL
	LDR R1, =7
	STR R1, [R0]
	
	BX LR

SysTick_Handler
	
			MVN R7, R7
			LDR R8, =0x4001080C
			STR R7, [R8]
			BX LR
			
			ALIGN
			END
				