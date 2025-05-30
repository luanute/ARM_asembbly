RCC_APB2ENR     EQU    0x40021018	

GPIOA_CRL	    EQU    0x40010800
GPIOA_CRH	    EQU    0x40010804
GPIOA_IDR	    EQU    0x40010808
GPIOA_ODR	    EQU    0x4001080C
GPIOA_BSRR      EQU    0x40010810

GPIOB_CRL	    EQU    0x40010C00
GPIOB_CRH	    EQU    0x40010C04
GPIOB_IDR	    EQU    0x40010C08
GPIOB_ODR	    EQU    0x40010C0C


GPIOC_CRL	    EQU    0x40011000
GPIOC_CRH	    EQU    0x40011004
GPIOC_IDR	    EQU    0x40011008
GPIOC_ODR	    EQU    0x4001100C
	
; define các thanh ghi

    
	
              AREA GPIO, CODE, READONLY
              EXPORT __main
              
; khai báo mang		
MANG        DCB    0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

BIENDEM2        RN     R10
BIENDEM1        RN     R9
__main

	LDR R1,=RCC_APB2ENR
	LDR R0,[R1]
	ORR R0,R0,#0xC		;enable clocks cho chan GPIO
	STR R0,[R1]
	
	LDR R1,=GPIOA_CRL
	LDR R0,=0x33333333   ;chon che do output 
	STR R0,[R1]	
	
	LDR R1,=GPIOA_CRH
	LDR R0,=0x33
	STR R0,[R1]			
	
	LDR R1,=GPIOB_CRL
	LDR R0,=0x88        ; chon che do input cho chan
	STR R0,[R1]

NGAY     
  
D2X1
   	    
      MOV BIENDEM2,#20
      MOV BIENDEM1,#15
	  LDR R1,=GPIOA_ODR
      MOV R2,#2_1100000
      STR R2,[R1]
      BL XULIDATA
QLD2X1	   
	  SUBS BIENDEM1,#1
	  BLE D2V1
	  SUBS BIENDEM2,#1
	  BLE D2V1
        
	  BL XULIDATA
      B QLD2X1
D2V1
     
      MOV BIENDEM1,#5
	  MOV BIENDEM2,#5
	  LDR R1,=GPIOA_ODR
      MOV R2,#2_1010000
      STR R2,[R1]
      BL XULIDATA
QLD2V1	   
	  SUBS BIENDEM1,#1
	  BLE X2D1
	  SUBS BIENDEM2,#1
	  BLE X2D1
        
	  BL XULIDATA
      B QLD2V1
  
X2D1
      MOV BIENDEM2,#15
      MOV BIENDEM1,#20
	  LDR R1,=GPIOA_ODR
      MOV R2,#2_100001000
      STR R2,[R1]
      BL XULIDATA
QLX2D1	   
	  SUBS BIENDEM1,#1
	  BLE V2D1
	  SUBS BIENDEM2,#1
	  BLE V2D1
        
	  BL XULIDATA
      B QLX2D1	  
	  
	  
V2D1
      
	  MOV BIENDEM1,#5
	  MOV BIENDEM2,#5
	  LDR R1,=GPIOA_ODR
      MOV R2,#2_10001000
      STR R2,[R1]
      BL XULIDATA
QLV2D1	   
	  SUBS BIENDEM1,#1
	  BLE NGAY
	  SUBS BIENDEM2,#1
	  BLE NGAY
        
	  BL XULIDATA
      B QLV2D1	  
	
       
DEM
      LDR R1,=GPIOA_ODR
      MOV R2,#2_1010010000
      STR R2,[R1]
	  
	  LDR R3,=GPIOB_IDR
	  LDR R8,[R3]
	  CMP R8,#0x1
	  BEQ NGAY
	  
	  B DEM

XULIDATA	 	
        MOV R1,#31 
		MOV R8, #10
		UDIV R2,BIENDEM1,R8
		MUL R3,R2,R8
        SUBS R3,BIENDEM1,R3
        
		LDR R0,=MANG       ; lay dia chi dau tien trong mang vào R0   
        LDRB R2,[R0,R2]                
		LDRB R3,[R0,R3]	
		LSL R3,R3,#8	
    	ORR R2,R2,R3

        UDIV R4,BIENDEM2,R8
		MUL R3,R4,R8
        SUBS R5,BIENDEM2,R3
        
        LDRB R4,[R0,R4]                
		LDRB R5,[R0,R5]	
		LSL R4,R4,#16	
    	LSL R5,R5,#24
		ORR R4,R4,R5
		ORR R2,R2,R4
dich		
		
		LSR R3,R2,R1
	    AND R3,#0x1
	  
	    CMP R3,#0
	    BEQ CLEAR              ;neu bit 0 thi clear, 1 thi set 
	    LDR R3,=GPIOA_BSRR
	    MOV R4,#0x2
	    STR R4,[R3]
	    B NEXT
CLEAR
        LDR R3,=GPIOA_BSRR
        MOV R4,#0x20000
	    STR R4,[R3]
NEXT
        LDR R3,=GPIOA_BSRR      ;dich data
	    MOV R4,#0x1
	    STR R4,[R3]	 
        MOV R4,#0x10000
	    STR R4,[R3]
   
        LDR R3,=GPIOB_IDR
		LDR R8,[R3]
		CMP R8,#0x2	
		BEQ DEM
		
		
		SUBS R1,R1,#1
	    BGE dich
	 
	    LDR R3,=GPIOA_BSRR
	    MOV R4,#0x4
	    STR R4,[R3]	 
        MOV R4,#0x40000        
	    STR R4,[R3]
;chot du lieu ra chan q		
		
        PUSH {LR}
		BL delay 
		POP{LR}
		
		BX LR
		
delay 
		LDR R11,=1200000
d_L2	SUBS R11,R11,#1
		BNE d_L2
		BX LR

END
