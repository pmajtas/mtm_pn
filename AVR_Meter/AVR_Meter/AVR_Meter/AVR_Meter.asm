/*
 * AVR_Meter.asm
 *
 *  Created: 10/2/2019 2:39:02 PM
 *   Author: student
 */ 

; AssemblerApplication1.asm
;
; Created: 2019-10-01 20:15:00
; Author : Moj 


;cw49
.MACRO LOAD_CONST  
	LDI @0, LOW(@2)
	LDI @1, HIGH(@2)
.ENDMACRO

.MACRO SET_DIGIT 
	RCALL DigitTo7segCode
	OUT Segments_P, R27
	LDI R18, (2<<@0)
	OUT Digits_P, R18
	
	RCALL DelayInMs
	CLC
.ENDMACRO

.cseg ; segment pamiêci kodu programu;
.org 0 rjmp _main ; skok po resecie (do programu g³ównego)
.org 4 rjmp _timer_isr ; skok do obs³ugi przerwania timera,
.org 0xb rjmp _pin_isr 


_pin_isr:
	
	ADD PulseEdgeCtrL, R4
	ADC PulseEdgeCtrH, R3
	CLC
	
reti



_timer_isr: ; procedura obs³ugi przerwania timera;;
	
	RCALL NumberToDigits

	CLR PulseEdgeCtrL
	CLR PulseEdgeCtrH	

reti ; powrót z procedury obs³ugi przerwania (reti zamiast ret)


_main:	


.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Dig0=R5 ; Digits temps
.def Dig1=R6 ;
.def Dig2=R7 ;
.def Dig3=R8 ;



.equ Digits_P = PORTB  ; .equ is like #define in C:
.equ Segments_P = PORTD


	LDI R16, (1<<7)
	OUT SREG,  R16

	LDI R16, 0b1100
	OUT TCCR1B , R16 ;

	LDI R16, HIGH(15625) //wpisaæ 100 dla ok25600 cykli - 31250 - 1sek
	OUT OCR1AH ,R16
	LDI R16, LOW(15625)
	OUT OCR1AL, R16 

	LDI R16, (1<<6)
	OUT TIMSK , R16
	CLR R16

	LDI R16, 0b00100000;$38;$df
	OUT GIMSK, R16

	LDI R16, 0b1 ;pcint0 
	OUT PCMSK, R16


LDI R20, $35
LDI R21, $6
LDI R18, 1
MOV R4, R18
CLR R3
LOAD_CONST R16,R17,5
LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie 0-6
LDI R26, 0x1e ; otworzenie pinów 1-4

OUT DDRD, R23
OUT DDRB, R26

CLR R28
CLR R23 

MainLoop: 
 
	MOV R27, Dig3
	SET_DIGIT 3

	MOV R27, Dig2
	SET_DIGIT 2

	MOV R27, Dig1
	SET_DIGIT 1

	MOV R27, Dig0
	SET_DIGIT 0


RJMP MainLoop


DelayInMs:

	PUSH R16
	PUSH R17

	OneMs: RCALL DelayOneMs 
	
	Timer: CLN 
	CLC
	SBC R16,R4
	BRBS 1, OldTimer
	BRBS 0, OldTimer
	RJMP OneMs

	OldTimer: CLN 
	SUB R17,R4
	BRBS 2, DelayEnd
	RJMP Timer


DelayEnd:POP R17
		POP R16 
		RET

		DelayOneMs:
			PUSH R21
			PUSH R20

			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
			NOP
			BRBS 1, Loop2
			RJMP Loop1

			Loop2: DEC R21
			BRBS 2, End 
			RJMP Loop1

			End: 
			POP R20
			POP R21
			CLN
		RET

DigitTo7segCode:
	
		LDI R30, Low(Table<<1)
		LDI R31, High(Table<<1)

		ADD R30, R27
		ADC R31, R3
		LPM R27, Z 
			
	RET
	Table: .db 0x3f, 0x6, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x7, 0x7f, 0x6f


NumberToDigits:
	CLR R29
	PUSH R0
	PUSH R1

	LDI R18, LOW(1000)
	LDI R19, HIGH(1000)

	Comp0:
	CP PulseEdgeCtrL, R18
	CPC PulseEdgeCtrH,R19
	BRLO Res0
	RJMP Subs0

	Subs0:
	
	SUB PulseEdgeCtrL,R18
	SBC PulseEdgeCtrH,R19
	ADD R29, R4
	RJMP Comp0

	Res0:
	MOV Dig0, R29 //wynik
	LDI R18, LOW(100)
	LDI R19, HIGH(100)
	CLR R29

	Comp1:
	CP PulseEdgeCtrL, R18
	CPC PulseEdgeCtrH,R19
	BRLO Res1
	RJMP Subs1

	Subs1:
	SUB PulseEdgeCtrL,R18
	SBC PulseEdgeCtrH,R19
	ADD R29, R4	
	RJMP Comp1

	Res1:
	MOV Dig1, R29
	LDI R18, LOW(10)
	LDI R19, HIGH(10)
	CLR R29

	Comp2:
	CP PulseEdgeCtrL, R18
	CPC PulseEdgeCtrH,R19
	BRLO Res2
	RJMP Subs2

	Subs2:
	SUB PulseEdgeCtrL,R18
	SBC PulseEdgeCtrH,R19
	ADD R29, R4
	RJMP Comp2

	Res2:
	MOV Dig2, R29 //wynik
	MOV Dig3, PulseEdgeCtrL

	pop r1
	pop r0
	
RET

	Divide:
		LDI R18, LOW(10000)
		LDI R19, HIGH(10000)
		Comp:
		CP PulseEdgeCtrL, R18
		CPC PulseEdgeCtrH,R19
		BRLO Res
		RJMP Subs
	
		Subs:
		SUB PulseEdgeCtrL,R18
		SBC PulseEdgeCtrH,R19
		RJMP Comp

		Res:
		
	RET

/*
;cw48 
.cseg ; segment pamiêci kodu programu;
.org 0 rjmp _main ; skok po resecie (do programu g³ównego)

//.org 4 rjmp _timer_isr ; skok do obs³ugi przerwania timera,
.org 0xb rjmp _pin_isr ;INT0addr


_pin_isr:
	
	CLC
	ADD PulseEdgeCtrL, R4
	ADC PulseEdgeCtrH, R3
	STS 0x62, PulseEdgeCtrL
	STS 0x63, PulseEdgeCtrH

	RCALL Divide
	RCALL NumberToDigits
	
reti



_timer_isr: ; procedura obs³ugi przerwania timera;;


CLC
	ADD PulseEdgeCtrL, R4
	ADC PulseEdgeCtrH, R3
	STS 0x62, PulseEdgeCtrL
	STS 0x63, PulseEdgeCtrH

	RCALL Divide
	RCALL NumberToDigits

reti ; powrót z procedury obs³ugi przerwania (reti zamiast ret)


_main:

	


.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Dig0=R22 ; Digits temps
.def Dig1=R23 ;
.def Dig2=R24 ;
.def Dig3=R25 ;

.MACRO LOAD_CONST  
	LDI @0, LOW(@2)
	LDI @1, HIGH(@2)
.ENDMACRO

.MACRO SET_DIGIT 
	LDI R17, (2<<@0)
	RCALL DigitTo7segCode
	OUT Segments_P, R27
	OUT Digits_P, R17
	RCALL DelayInMs
	CLC
.ENDMACRO

.equ Digits_P = PORTB  ; .equ is like #define in C:
.equ Segments_P = PORTD


	LDI R16, (1<<7)
	OUT SREG,  R16

	 LDI R16, 0b1100
	OUT TCCR1B , R16 ;

	LDI R16, HIGH(31250) //wpisaæ 100 dla ok25600 cykli
	OUT OCR1AH ,R16
	LDI R16, LOW(31250)
	OUT OCR1AL, R16 

	LDI R16, (1<<6)
	OUT TIMSK , R16
	CLR R16 

	LDI R16, $38;$df
	OUT GIMSK, R16

	LDI R16, 0b1 ;pcint0 
	OUT PCMSK, R16

	LDI R16, 0b1
	OUT MCUCR, R16


LDI R20, $35
LDI R21, $6
LDI R18, 1
MOV R4, R18
LDI R19, 0
CLR R3
LOAD_CONST R16,R17, 5
STS 0x60, R16
STS 0x61, R17
LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie 0-6
LDI R26, 0x1e ; otworzenie pinów 1-4

OUT DDRD, R23
OUT DDRB, R26
CLR R29
CLR R28
CLR R27
CLR R24
CLR R23 
MainLoop: 

	Start: 
	MOV R27, Dig3
	SET_DIGIT 3

	MOV R27, Dig2
	SET_DIGIT 2

	MOV R27, Dig1
	SET_DIGIT 1

	MOV R27, Dig0
	SET_DIGIT 0


RJMP MainLoop


DelayInMs:
	LDS R16, 0x60
	LDS R17, 0x61

	OneMs: RCALL DelayOneMs 
	
	Timer: CLN 
	CLC
	SBC R16,R4
	BRBS 1, OldTimer
	BRBS 0, OldTimer
	RJMP OneMs

	OldTimer: CLN 
	SUB R17,R4
	BRBS 2, DelayEnd
	RJMP Timer


DelayEnd: RET

		DelayOneMs:
			PUSH R21
			PUSH R20

			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
			NOP
			BRBS 1, Loop2
			RJMP Loop1

			Loop2: DEC R21
			BRBS 2, End 
			RJMP Loop1

			End: 
			POP R20
			POP R21
			CLN
		RET

DigitTo7segCode:
		CLR R3
		LDI R30, Low(Table<<1)
		LDI R31, High(Table<<1)

		ADD R30, R27
		ADC R31, R3
		LPM R27, Z 
			
	RET
	Table: .db 0x3f, 0x6, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x7, 0x7f, 0x6f


NumberToDigits:
	CLR R29
	LDI R18, LOW(1000)
	LDI R19, HIGH(1000)

	Comp0:
	CP PulseEdgeCtrL, R18
	CPC PulseEdgeCtrH,R19
	BRLO Res0
	RJMP Subs0

	Subs0:
	
	SUB PulseEdgeCtrL,R18
	SBC PulseEdgeCtrH,R19
	ADD R29, R4
	RJMP Comp0

	Res0:
	MOV Dig0, R29 //wynik
	LDI R18, LOW(100)
	LDI R19, HIGH(100)
	CLR R29

	Comp1:
	CP PulseEdgeCtrL, R18
	CPC PulseEdgeCtrH,R19
	BRLO Res1
	RJMP Subs1

	Subs1:
	SUB PulseEdgeCtrL,R18
	SBC PulseEdgeCtrH,R19
	ADD R29, R4	
	RJMP Comp1

	Res1:
	MOV Dig1, R29
	LDI R18, LOW(10)
	LDI R19, HIGH(10)
	CLR R29

	Comp2:
	CP PulseEdgeCtrL, R18
	CPC PulseEdgeCtrH,R19
	BRLO Res2
	RJMP Subs2

	Subs2:
	SUB PulseEdgeCtrL,R18
	SBC PulseEdgeCtrH,R19
	ADD R29, R4
	RJMP Comp2

	Res2:
	MOV Dig2, R29 //wynik
	MOV Dig3, PulseEdgeCtrL
	LDS PulseEdgeCtrL, 0x62
	LDS PulseEdgeCtrH, 0x63

	
RET

	Divide:
		LDI R18, LOW(10000)
		LDI R19, HIGH(10000)
		Comp:
		CP PulseEdgeCtrL, R18
		CPC PulseEdgeCtrH,R19
		BRLO Res
		RJMP Subs
	
		Subs:
		SUB PulseEdgeCtrL,R18
		SBC PulseEdgeCtrH,R19
		RJMP Comp

		Res:
		
	RET */



;cw45-46-47 
/*
.cseg ; segment pamiêci kodu programu;
.org 0 rjmp _main ; skok po resecie (do programu g³ównego)
.org 4 rjmp _timer_isr ; skok do obs³ugi przerwania timera, timer counter compare match A ;
_timer_isr: ; procedura obs³ugi przerwania timera;;



CLC
	ADD PulseEdgeCtrL, R4
	ADC PulseEdgeCtrH, R3
	STS 0x62, PulseEdgeCtrL
	STS 0x63, PulseEdgeCtrH

	RCALL Divide
	RCALL NumberToDigits
reti ; powrót z procedury obs³ugi przerwania (reti zamiast ret)

_main:

	


.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Dig0=R22 ; Digits temps
.def Dig1=R23 ;
.def Dig2=R24 ;
.def Dig3=R25 ;

.MACRO LOAD_CONST  
	LDI @0, LOW(@2)
	LDI @1, HIGH(@2)
.ENDMACRO

.MACRO SET_DIGIT 
	LDI R17, (2<<@0)
	RCALL DigitTo7segCode
	OUT Segments_P, R27
	OUT Digits_P, R17
	RCALL DelayInMs
.ENDMACRO

.equ Digits_P = PORTB  ; .equ is like #define in C:
.equ Segments_P = PORTD


	LDI R16, 0b10000000
	OUT SREG,  R16

	LDI R16, 0b1100
	OUT TCCR1B , R16 ;

	LDI R16, HIGH(31250) //wpisaæ 100 dla ok25600 cykli
	OUT OCR1AH ,R16
	LDI R16, LOW(31250)
	OUT OCR1AL, R16 

	LDI R16, (1<<6)
	OUT TIMSK , R16
	CLR R16


LDI R20, $35
LDI R21, $6
LDI R18, 1
MOV R4, R18
LDI R19, 0
CLR R3
LOAD_CONST R16,R17, 5
STS 0x60, R16
STS 0x61, R17
LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie 0-6
LDI R26, 0x1e ; otworzenie pinów 1-4

OUT DDRD, R23
OUT DDRB, R26
CLR R29
CLR R28
CLR R27
CLR R24
CLR R23

MainLoop: 

	Start: 
	MOV R27, Dig3
	SET_DIGIT 3

	MOV R27, Dig2
	SET_DIGIT 2

	MOV R27, Dig1
	SET_DIGIT 1

	MOV R27, Dig0
	SET_DIGIT 0


RJMP MainLoop


DelayInMs:
	LDS R16, 0x60
	LDS R17, 0x61

	OneMs: RCALL DelayOneMs 
	
	Timer: CLN 
	CLC
	SBC R16,R4
	BRBS 1, OldTimer
	BRBS 0, OldTimer
	RJMP OneMs

	OldTimer: CLN 
	SUB R17,R4
	BRBS 2, DelayEnd
	RJMP Timer


DelayEnd: RET

		DelayOneMs:
			PUSH R21
			PUSH R20

			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
			NOP
			BRBS 1, Loop2
			RJMP Loop1

			Loop2: DEC R21
			BRBS 2, End 
			RJMP Loop1

			End: 
			POP R20
			POP R21
			CLN
		RET

DigitTo7segCode:
		CLR R3
		LDI R30, Low(Table<<1)
		LDI R31, High(Table<<1)

		ADD R30, R27
		ADC R31, R3
		LPM R27, Z 
			
	RET
	Table: .db 0x3f, 0x6, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x7, 0x7f, 0x6f


NumberToDigits:
	CLR R29
	LDI R18, LOW(1000)
	LDI R19, HIGH(1000)

	Comp0:
	CP PulseEdgeCtrL, R18
	CPC PulseEdgeCtrH,R19
	BRLO Res0
	RJMP Subs0

	Subs0:
	
	SUB PulseEdgeCtrL,R18
	SBC PulseEdgeCtrH,R19
	ADD R29, R4
	RJMP Comp0

	Res0:
	MOV Dig0, R29 //wynik
	LDI R18, LOW(100)
	LDI R19, HIGH(100)
	CLR R29

	Comp1:
	CP PulseEdgeCtrL, R18
	CPC PulseEdgeCtrH,R19
	BRLO Res1
	RJMP Subs1

	Subs1:
	SUB PulseEdgeCtrL,R18
	SBC PulseEdgeCtrH,R19
	ADD R29, R4	
	RJMP Comp1

	Res1:
	MOV Dig1, R29
	LDI R18, LOW(10)
	LDI R19, HIGH(10)
	CLR R29

	Comp2:
	CP PulseEdgeCtrL, R18
	CPC PulseEdgeCtrH,R19
	BRLO Res2
	RJMP Subs2

	Subs2:
	SUB PulseEdgeCtrL,R18
	SBC PulseEdgeCtrH,R19
	ADD R29, R4
	RJMP Comp2

	Res2:
	MOV Dig2, R29 //wynik
	MOV Dig3, PulseEdgeCtrL
	LDS PulseEdgeCtrL, 0x62
	LDS PulseEdgeCtrH, 0x63

	
RET

	Divide:
		LDI R18, LOW(10000)
		LDI R19, HIGH(10000)
		Comp:
		CP PulseEdgeCtrL, R18
		CPC PulseEdgeCtrH,R19
		BRLO Res
		RJMP Subs
	
		Subs:
		SUB PulseEdgeCtrL,R18
		SBC PulseEdgeCtrH,R19
		RJMP Comp

		Res:
		
	RET */
	


;cw44
;
;.def PulseEdgeCtrL=R0
;.def PulseEdgeCtrH=R1
;
;.def Dig0=R22 ; Digits temps
;.def Dig1=R23 ;
;.def Dig2=R24 ;
;.def Dig3=R25 ;
;
;.MACRO LOAD_CONST  
;	LDI @0, LOW(@2)
;	LDI @1, HIGH(@2)
;.ENDMACRO
;
;.MACRO SET_DIGIT 
;	LDI R17, (2<<@0)
;	RCALL DigitTo7segCode
;	OUT Segments_P, R27
;	OUT Digits_P, R17
;	RCALL DelayInMs
;.ENDMACRO
;
;.equ Digits_P = PORTB  ; .equ is like #define in C:
;.equ Segments_P = PORTD
;
;LDI R20, $35
;LDI R21, $6
;LDI R18, 1
;MOV R4, R18
;LDI R19, 0
;CLR R3
;LOAD_CONST R16,R17, 10
;STS 0x60, R16
;STS 0x61, R17
;LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie 0-6
;LDI R26, 0x1e ; otworzenie pinów 1-4
;
;OUT DDRD, R23
;OUT DDRB, R26
;CLR R29
;CLR R28
;CLR R27
;CLR R24
;
;MainLoop: 
;	CLC
;	ADD PulseEdgeCtrL, R4
;	ADC PulseEdgeCtrH, R3
;	STS 0x62, PulseEdgeCtrL
;	STS 0x63, PulseEdgeCtrH
;
;	RCALL Divide
;	RCALL NumberToDigits
;
;	Start: 
;	MOV R27, Dig3
;	SET_DIGIT 3
;
;	MOV R27, Dig2
;	SET_DIGIT 2
;
;	MOV R27, Dig1
;	SET_DIGIT 1
;
;	MOV R27, Dig0
;	SET_DIGIT 0
;
;
;RJMP MainLoop
;
;
;DelayInMs:
;	LDS R16, 0x60
;	LDS R17, 0x61
;
;	OneMs: RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R4
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP OneMs
;
;	OldTimer: CLN 
;	SUB R17,R4
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: RET
;
;		DelayOneMs:
;			PUSH R21
;			PUSH R20
;
;			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;			NOP
;			BRBS 1, Loop2
;			RJMP Loop1
;
;			Loop2: DEC R21
;			BRBS 2, End 
;			RJMP Loop1
;
;			End: 
;			POP R20
;			POP R21
;			CLN
;		RET
;
;DigitTo7segCode:
;		CLR R3
;		LDI R30, Low(Table<<1)
;		LDI R31, High(Table<<1)
;
;		ADD R30, R27
;		ADC R31, R3
;		LPM R27, Z 
;			
;	RET
;	Table: .db 0x3f, 0x6, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x7, 0x7f, 0x6f
;
;
;NumberToDigits:
;	CLR R29
;	LDI R18, LOW(1000)
;	LDI R19, HIGH(1000)
;
;	Comp0:
;	CP PulseEdgeCtrL, R18
;	CPC PulseEdgeCtrH,R19
;	BRLO Res0
;	RJMP Subs0
;
;	Subs0:
;	
;	SUB PulseEdgeCtrL,R18
;	SBC PulseEdgeCtrH,R19
;	ADD R29, R4
;	RJMP Comp0
;
;	Res0:
;	MOV Dig0, R29 //wynik
;	LDI R18, LOW(100)
;	LDI R19, HIGH(100)
;	CLR R29
;
;	Comp1:
;	CP PulseEdgeCtrL, R18
;	CPC PulseEdgeCtrH,R19
;	BRLO Res1
;	RJMP Subs1
;
;	Subs1:
;	SUB PulseEdgeCtrL,R18
;	SBC PulseEdgeCtrH,R19
;	ADD R29, R4	
;	RJMP Comp1
;
;	Res1:
;	MOV Dig1, R29
;	LDI R18, LOW(10)
;	LDI R19, HIGH(10)
;	CLR R29
;
;	Comp2:
;	CP PulseEdgeCtrL, R18
;	CPC PulseEdgeCtrH,R19
;	BRLO Res2
;	RJMP Subs2
;
;	Subs2:
;	SUB PulseEdgeCtrL,R18
;	SBC PulseEdgeCtrH,R19
;	ADD R29, R4
;	RJMP Comp2
;
;	Res2:
;	MOV Dig2, R29 //wynik
;	MOV Dig3, PulseEdgeCtrL
;	LDS PulseEdgeCtrL, 0x62
;	LDS PulseEdgeCtrH, 0x63
;
;	
;RET
;
;	Divide:
;		LDI R18, LOW(10000)
;		LDI R19, HIGH(10000)
;		Comp:
;		CP PulseEdgeCtrL, R18
;		CPC PulseEdgeCtrH,R19
;		BRLO Res
;		RJMP Subs
;	
;		Subs:
;		SUB PulseEdgeCtrL,R18
;		SBC PulseEdgeCtrH,R19
;		RJMP Comp
;
;		Res:
;		
;	RET
;
;
;
;cw43
;
;.def Dig0=R22 ; Digits temps
;.def Dig1=R23 ;
;.def Dig2=R24 ;
;.def Dig3=R25 ;
;
;LDI R16, LOW(4965)
;LDI R17, HIGH(4965)
;LDI R18, LOW(1000)
;LDI R19, HIGH(1000)
;LDI R22, 1
;MOV R0, R22
;
;
;NumberToDigits:
;	
;	Comp0:
;	CP R16, R18
;	CPC R17,R19
;	BRLO Res0
;	RJMP Subs0
;
;	Subs0:
;	SUB R16,R18
;	SBC R17,R19
;	ADD R29, R0	
;	RJMP Comp0
;
;	Res0:
;	MOV Dig0, R29 //wynik
;	LDI R18, LOW(100)
;	LDI R19, HIGH(100)
;	CLR R29
;
;	Comp1:
;	CP R16, R18
;	CPC R17,R19
;	BRLO Res1
;	RJMP Subs1
;
;	Subs1:
;	SUB R16,R18
;	SBC R17,R19
;	ADD R29, R0	
;	RJMP Comp1
;
;	Res1:
;	MOV Dig1, R29
;	LDI R18, LOW(10)
;	LDI R19, HIGH(10)
;	CLR R29
;
;	Comp2:
;	CP R16, R18
;	CPC R17,R19
;	BRLO Res2
;	RJMP Subs2
;
;	Subs2:
;	SUB R16,R18
;	SBC R17,R19
;	ADD R29, R0	
;	RJMP Comp2
;
;	Res2:
;	MOV Dig2, R29 //wynik
;	LDI R18, LOW(1)
;	LDI R19, HIGH(1)
;	CLR R29
;
;	Comp3:
;	CP R16, R18
;	CPC R17,R19
;	BRLO Res3
;	RJMP Subs3
;
;	Subs3:
;	SUB R16,R18
;	SBC R17,R19
;	ADD R29, R0	
;	RJMP Comp3
;
;	Res3:
;	MOV Dig3, R29 //wynik
;	CLR R29
;	
;RET

;cw42
;*** Divide ***
; X/Y -> Qotient,Reminder
; Input/Output: R16-19, Internal R24-25

; inputs
/*.def XL=R16 ; divident
.def XH=R17
.def YL=R18 ; divider
.def YH=R19

; outputs
.def RL=R16 ; reminder
.def RH=R17
.def QL=R18 ; quotient
.def QH=R19

; internal
.def QCtrL=R24
.def QCtrH=R25*/

;LDI R16, LOW(1200)
;LDI R17, HIGH(1200)
;LDI R18, LOW(500)
;LDI R19, HIGH(500)
;CLR R1
;LDI R22, 1
;MOV R0, R22
;
;Divide:
;	
;	Comp:
;	CP R16, R18
;	CPC R17,R19
;	BRLO Res
;	RJMP Subs
;
;	Subs:
;	SUB R16,R18
;	SBC R17,R19
;	ADD R24, R0
;	ADC R25,R1
;	RJMP Comp
;
;	Res:
;	MOV R18,R16//reszta
;	MOV R19,R17//
;	MOV R16, R24 //wynik
;	MOV R17, R25//
;	
;RET
;
;
;cw41
;.MACRO LOAD_CONST  
;	LDI @0, LOW(@2)
;	LDI @1, HIGH(@2)
;.ENDMACRO
;
;.MACRO SET_DIGIT 
;	LDI R17, (2<<@0)
;	RCALL DigitTo7segCode
;	OUT Segments_P, R26
;	OUT Digits_P, R17
;	RCALL DelayInMs
;.ENDMACRO
;
;.equ Digits_P = PORTB  ; .equ is like #define in C:
;.equ Segments_P = PORTD
;
;LDI R20, $35
;LDI R21, $6
;LDI R18, 1
;LDI R19, 0
;LOAD_CONST R16,R17, 5
;STS 0x60, R16
;STS 0x61, R17
;LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie 0-6
;LDI R26, 0x1e ; otworzenie pinów 1-4
;
;OUT DDRD, R23
;OUT DDRB, R26
;CLR R29
;CLR R28
;CLR R27
;CLR R24
;
;MainLoop: 
;	Start: 
;	MOV R26, R29
;	SET_DIGIT 3
;	MOV R26, R28
;	SET_DIGIT 2
;	MOV R26,R27
;	SET_DIGIT 1
;	MOV R26, R24
;	SET_DIGIT 0
;
;
;	INC R29
;	CPI R29, 10
;	BRNE Start
;	CLR R29
;
;	INC R28
;	CPI R28,10
;	BRNE Start
;	CLR R28
;
;	INC R27
;	CPI R27,10
;	BRNE Start
;	CLR R27
;
;	INC R24
;	CPI R24,10
;	BRNE Start
;	CLR R24
;
;
;RJMP MainLoop
;
;
;DelayInMs:
;	LDS R16, 0x60
;	LDS R17, 0x61
;
;	OneMs: RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP OneMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: RET
;
;		DelayOneMs:
;			PUSH R21
;			PUSH R20
;
;			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;			NOP
;			BRBS 1, Loop2
;			RJMP Loop1
;
;			Loop2: DEC R21
;			BRBS 2, End 
;			RJMP Loop1
;
;			End: 
;			POP R20
;			POP R21
;			CLN
;		RET
;
;	DigitTo7segCode:
;		LDI R25, 0
;		LDI R30, Low(Table<<1)
;		LDI R31, High(Table<<1)
;
;		ADD R30, R26
;		ADC R31, R25
;		LPM R26, Z 
;			
;	RET
;	Table: .db 0x3f, 0x6, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x7, 0x7f, 0x6f
;
;
;cw40
;.MACRO LOAD_CONST  
;	LDI @0, LOW(@2)
;	LDI @1, HIGH(@2)
;.ENDMACRO
;
;.MACRO SET_DIGIT 
;	LDI R17, (2<<@0) 
;	;LDI R26, 0
;	RCALL DigitTo7segCode
;	OUT Segments_P, R26
;	OUT Digits_P, R17
;	RCALL DelayInMs
;.ENDMACRO
;
;.equ Digits_P = PORTB  ; .equ is like #define in C:
;.equ Segments_P = PORTD
;
;LDI R20, $35
;LDI R21, $6
;LDI R18, 1
;LDI R19, 0
;LOAD_CONST R16,R17, 1000
;STS 0x60, R16
;STS 0x61, R17
;LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie 0-6
;LDI R26, 0x1e ; otworzenie pinów 1-4;
;
;OUT DDRD, R23
;OUT DDRB, R26
;CLR R29
;
;MainLoop: 
;	Start: MOV R26, R29
;	SET_DIGIT 3
;	INC R29
;	CPI R29, 10
;	BRNE Start
;	CLR R29
;
;RJMP MainLoop
;
;
;DelayInMs:
;	LDS R16, 0x60
;	LDS R17, 0x61
;
;	OneMs: RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP OneMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: RET
;
;		DelayOneMs:
;			PUSH R21
;			PUSH R20
;
;			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;			NOP
;			BRBS 1, Loop2
;			RJMP Loop1
;
;			Loop2: DEC R21
;			BRBS 2, End 
;			RJMP Loop1
;
;			End: 
;			POP R20
;			POP R21
;			CLN
;		RET
;
;	DigitTo7segCode:
;		LDI R25, 0
;		LDI R30, Low(Table<<1)
;		LDI R31, High(Table<<1)
;
;		ADD R30, R26
;		ADC R31, R25
;		LPM R26, Z 
;			
;	RET
;	Table: .db 0x3f, 0x6, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x7, 0x7f, 0x6f
;
;cw39b
;.MACRO LOAD_CONST  
;	LDI @0, LOW(@2)
;	LDI @1, HIGH(@2)
;.ENDMACRO
;
;.MACRO SET_DIGIT
;	LDI R17, 2<<@0 ; 1 cyfra
;	LDI R26, 7
;	RCALL DigitTo7segCode
;	OUT Segments_P, R26
;	OUT Digits_P, R17
;	RCALL DelayInMs
;.ENDMACRO
;
;.equ Digits_P = PORTB  ; .equ is like #define in C:
;.equ Segments_P = PORTD
;
;LDI R20, $35
;LDI R21, $6
;LDI R18, 1
;LOAD_CONST R16,R17, 5
;STS 0x60, R16
;STS 0x61, R17
;LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie 0-6
;LDI R26, 0x1e ; otworzenie pinów 1-4
;
;
;OUT DDRD, R23
;OUT DDRB, R26
;
;MainLoop: 
;
;	SET_DIGIT 0
;	SET_DIGIT 1
;	SET_DIGIT 2
;	SET_DIGIT 3
;
;RJMP MainLoop
;
;
;
;DelayInMs:
;	LDS R16, 0x60
;	LDS R17, 0x61
;
;	OneMs: RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP OneMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: RET
;
;		DelayOneMs:
;			PUSH R21
;			PUSH R20
;
;			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;			NOP
;			BRBS 1, Loop2
;			RJMP Loop1
;
;			Loop2: DEC R21
;			BRBS 2, End 
;			RJMP Loop1
;
;			End: 
;			POP R20
;			POP R21
;			CLN
;		RET
;
;	DigitTo7segCode:
;		LDI R25, 0
;		LDI R30, Low(Table<<1)
;		LDI R31, High(Table<<1)
;
;		ADD R30, R26
;		ADC R31, R25
;		LPM R26, Z 
;			
;	RET
;	Table: .db 0x3f, 0x6, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x7, 0x7f, 0x6f
;
;cw39
;.MACRO LOAD_CONST  
;LDI @0, LOW(@2)
;LDI @1, HIGH(@2)
;.ENDMACRO
;
;.equ Digits_P = PORTB  ; .equ is like #define in C:
;.equ Segments_P = PORTD
;
;LDI R20, $35
;LDI R21, $6
;LDI R18, 1
;LOAD_CONST R16,R17, 5
;STS 0x60, R16
;STS 0x61, R17
;LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie 0-6
;LDI R26, 0x1e ; otworzenie pinów 1-4
;
;
;OUT DDRD, R23
;OUT DDRB, R26
;
;MAIN: 
;	LDI R17, 0x8 ;3 cyfra
;	LDI R26,5
;	RCALL DigitTo7segCode
;	OUT Segments_P, R26
;	OUT Digits_P, R17
;	RCALL DelayInMs 
;
;	
;	LDI R17, 0x4 ;2 cyfra
;	LDI R26, 6
;	RCALL DigitTo7segCode
;	OUT Segments_P, R26
;	OUT Digits_P, R17
;	RCALL DelayInMs 
;
;	
;	LDI R17, 0x2 ; 1 cyfra
;	LDI R26, 7
;	RCALL DigitTo7segCode
;	OUT Segments_P, R26
;	OUT Digits_P, R17
;	RCALL DelayInMs
;
;	
;	LDI R17, 0x10 ;4 cyfra
;	LDI R26, 4
;	RCALL DigitTo7segCode
;	OUT Segments_P, R26
;	OUT Digits_P, R17
;	RCALL DelayInMs
;
;RJMP MAIN
;
;
;
;DelayInMs:
;	LDS R16, 0x60
;	LDS R17, 0x61
;
;	OneMs: RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP OneMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: RET
;
;		DelayOneMs:
;			PUSH R21
;			PUSH R20
;
;			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;			NOP
;			BRBS 1, Loop2
;			RJMP Loop1
;
;			Loop2: DEC R21
;			BRBS 2, End 
;			RJMP Loop1
;
;			End: 
;			POP R20
;			POP R21
;			CLN
;		RET
;
;	DigitTo7segCode:
;		LDI R25, 0
;		LDI R30, Low(Table<<1)
;		LDI R31, High(Table<<1)
;
;		ADD R30, R26
;		ADC R31, R25
;		LPM R26, Z 
;			
;	RET
;	Table: .db 0x3f, 0x6, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x7, 0x7f, 0x6f
;
;cw38
;LDI R30, Low(Table<<1) 
;LDI R31, High(Table<<1)
;LDI R16, 3
;STS 0x60, R16
;RCALL DigitTo7segCode 
;NOP
;
;DigitTo7segCode:
;
;	ADIW R30:R31, 3
;	LPM R16, Z 
;	LDS R16, 0x60
;	NOP
;		Table: .db 0x3f, 0x6, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x7, 0x7f, 0x6f
;RET
;
;cw37
;LDI R30, Low(Table<<1) 
;LDI R31, High(Table<<1)
;LDI R16, 3
;RCALL Square 
;NOP
;
;Square:
;
;	ADIW R30:R31, 3
;	LPM R16, Z 
;	NOP
;		Table: .db 0x0, 0x1, 0x4, 0x9, 0x10, 0x19, 0x23, 0x31, 0x40, 0x51
;RET
;
;cw36
// Program odczytuje 4 bajty z tablicy sta³ych zdefiniowanej w pamiêci kodu do rejestrów R20..R23
;ldi R30, Low(Table<<1) // inicjalizacja rejestru Z
;ldi R31, High(Table<<1)
;lpm R20, Z // odczyt pierwszej sta³ej z tablicy Table
;adiw R30:R31,1 // inkrementacja Z
;lpm R21, Z // odczyt drugiej sta³ej
;adiw R30:R31,1 // inkrementacja Z
;lpm R22, Z // odczyt trzeciej sta³ej
;adiw R30:R31,1 // inkrementacja Z
;lpm R23, Z // odczyt czwartej sta³ej
;nop
;Table: .db 0x57, 0x58, 0x59, 0x5A // UWAGA: liczba bajtów zdeklarowanych w
								// pamiêci kodu musi byæ parzysta

;cw35
;.MACRO LOAD_CONST  
;LDI @0, LOW(@2)
;LDI @1, HIGH(@2)
;.ENDMACRO
;
;#define DIGIT_0 R2
;#define DIGIT_1 R3
;#define DIGIT_2 R4
;#define DIGIT_3 R5
;
;.equ Digits_P = PORTB  ; .equ is like #define in C:
;.equ Segments_P = PORTD
;
;LDI R20, $35
;LDI R21, $6
;LDI R18, 1
;LOAD_CONST R16,R17, 5
;STS 0x60, R16
;STS 0x61, R17
;LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie 0-6
;LDI R26, 0x1e ; otworzenie pinów 1-4
;
;LDI R16, 0x3f
;MOV DIGIT_0,R16 ;"0"
;LDI R16, 0x6
;MOV DIGIT_1, R16 ;"1"
;LDI R16, 0x5b
;MOV DIGIT_2, R16 ;"2"
;LDI R16, 0x4f 
;MOV DIGIT_3, R16 ;"3"
;
;OUT DDRD, R23
;OUT DDRB, R26
;
;Zero: 
;	LDI R17, 0x8 ;3 cyfra
;	OUT Segments_P, DIGIT_2
;	OUT Digits_P, R17
;	RCALL DelayInMs 
;
;	
;	LDI R17, 0x4 ;2 cyfra
;	OUT Segments_P, DIGIT_1
;	OUT Digits_P, R17
;	RCALL DelayInMs 
;
;	
;	LDI R17, 0x2 ; 1 cyfra
;	OUT Segments_P, DIGIT_0
;	OUT Digits_P, R17
;	RCALL DelayInMs
;
;	
;	LDI R17, 0x10 ;4 cyfra
;	OUT Segments_P, DIGIT_3
;	OUT Digits_P, R17
;	RCALL DelayInMs
;
;RJMP Zero
;
;DelayInMs:
;	LDS R16, 0x60
;	LDS R17, 0x61
;
;	OneMs: RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP OneMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: 
;	;LDS R16, 0x60
;	;LDS R17, 0x61
;	RET
;
;		DelayOneMs:
;			PUSH R21
;			PUSH R20
;
;			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;			NOP
;			BRBS 1, Loop2
;			RJMP Loop1
;
;			Loop2: DEC R21
;			BRBS 2, End 
;			RJMP Loop1
;
;			End: 
;			POP R20
;			POP R21
;			CLN
;			RET
;
;cw34
;.MACRO LOAD_CONST  
;LDI @0, LOW(@2)
;LDI @1, HIGH(@2)
;.ENDMACRO
;
;.equ Digits_P = PORTB  ; .equ is like #define in C:
;.equ Segments_P = PORTD
;
;LDI R20, $35
;LDI R21, $6
;LDI R18, 1
;LOAD_CONST R16,R17, 5
;STS 0x60, R16
;STS 0x61, R17
;LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie 0-6
;LDI R26, 0x1e ; otworzenie pinów 1-4
;
;LDI R16, 0x3f
;MOV R2,R16 ;"0"
;LDI R16, 0x6
;MOV R3, R16 ;"1"
;LDI R16, 0x5b
;MOV R4, R16 ;"2"
;LDI R16, 0x4f 
;MOV R5, R16 ;"3"
;
;OUT DDRD, R23
;OUT DDRB, R26
;
;Zero: 
;	LDI R17, 0x8 ;3 cyfra
;	OUT Segments_P, R4
;	OUT Digits_P, R17
;	RCALL DelayInMs 
;
;	
;	LDI R17, 0x4 ;2 cyfra
;	OUT Segments_P, R3
;	OUT Digits_P, R17
;	RCALL DelayInMs 
;
;	
;	LDI R17, 0x2 ; 1 cyfra
;	OUT Segments_P, R2
;	OUT Digits_P, R17
;	RCALL DelayInMs
;
;	
;	LDI R17, 0x10 ;4 cyfra
;	OUT Segments_P, R5
;	OUT Digits_P, R17
;	RCALL DelayInMs
;
;RJMP Zero
;
;DelayInMs:
;	LDS R16, 0x60
;	LDS R17, 0x61
;
;	OneMs: RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP OneMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: 
;	;LDS R16, 0x60
;	;LDS R17, 0x61
;	RET
;
;		DelayOneMs:
;			PUSH R21
;			PUSH R20
;
;			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;			NOP
;			BRBS 1, Loop2
;			RJMP Loop1
;
;			Loop2: DEC R21
;			BRBS 2, End 
;			RJMP Loop1
;
;			End: 
;			POP R20
;			POP R21
;			CLN
;			RET
;
;cw33
;.MACRO LOAD_CONST  
;LDI @0, LOW(@2)
;LDI @1, HIGH(@2)
;.ENDMACRO
;
;.equ Digits_P = PORTB  ; .equ is like #define in C:
;.equ Segments_P = PORTD
;
;LDI R20, $35
;LDI R21, $6
;LDI R18, 1
;LOAD_CONST R16,R17, 5
;STS 0x60, R16
;STS 0x61, R17
;LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie 0-6
;LDI R26, 0x1e ; otworzenie pinów 1-4
;
;OUT DDRD, R23
;OUT DDRB, R26
;
;Zero: LDI R16, 0b1011011 ; cyfra "2"
;	LDI R17, 0x8 ;3cyfra
;	OUT Segments_P, R16
;	OUT Digits_P, R17
;	RCALL DelayInMs 
;
;	LDI R16, 0b110 ;cyfra "1"
;	LDI R17, 0x4 ;2 cyfra
;	OUT Segments_P, R16
;	OUT Digits_P, R17
;	RCALL DelayInMs 
;
;	LDI R16 , 0b111111 ;cyfra "0"
;	LDI R17, 0x2 ; 1 cyfra
;	OUT Segments_P, R16
;	OUT Digits_P, R17
;	RCALL DelayInMs
;
;	LDI R16, 0x4f ;cyfra "3"
;	LDI R17, 0x10 ;4cyfra
;	OUT Segments_P, R16
;	OUT Digits_P, R17
;	RCALL DelayInMs
;
;RJMP Zero
;
;DelayInMs:
;	LDS R16, 0x60
;	LDS R17, 0x61
;
;	OneMs: RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP OneMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: 
;	;LDS R16, 0x60
;	;LDS R17, 0x61
;	RET
;
;		DelayOneMs:
;			PUSH R21
;			PUSH R20
;
;			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;			NOP
;			BRBS 1, Loop2
;			RJMP Loop1
;
;			Loop2: DEC R21
;			BRBS 2, End 
;			RJMP Loop1
;
;			End: 
;			POP R20
;			POP R21
;			CLN
;			RET
;
;cw32
;.MACRO LOAD_CONST  
;LDI @0, LOW(@2)
;LDI @1, HIGH(@2)
;.ENDMACRO

;.equ Digits_P = PORTB  ; .equ is like #define in C:
;.equ Segments_P = PORTD
;
;LDI R20, $35
;LDI R21, $6
;LDI R18, 1
;LOAD_CONST R16,R17, 5
;STS 0x60, R16
;STS 0x61, R17
;LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie
;LDI R24, 0x3f ; "0"
;LDI R25, 0x10 ;4cyfra
;LDI R26, 0x1e
;
;OUT DDRD, R23
;OUT DDRB, R26
;
;Zero: OUT Segments_P, R24
;	OUT Digits_P, R25
;	LDI R25, 0x8 ;3cyfra
;	RCALL DelayInMs 
;
;	OUT Segments_P, R24
;	OUT Digits_P, R25
;	LDI R25, 0x4 ;2 cyfra
;	RCALL DelayInMs 
;
;	OUT Segments_P, R24
;	OUT Digits_P, R25
;	LDI R25, 0x2 ; 1 cyfra
;	RCALL DelayInMs
;
;	OUT Segments_P, R24
;	OUT Digits_P, R25
;	LDI R25, 0x10 ;4cyfra
;	RCALL DelayInMs
;
;RJMP Zero
;
;DelayInMs:
;	RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP DelayInMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: 
;	LDS R16, 0x60
;	LDS R17, 0x61
;	RET
;
;		DelayOneMs:
;			PUSH R21
;			PUSH R20
;
;			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;			NOP
;			BRBS 1, Loop2
;			RJMP Loop1
;
;			Loop2: DEC R21
;			BRBS 2, End 
;			RJMP Loop1
;
;			End: 
;			POP R20
;			POP R21
;			CLN
;			RET
;
;
;cw31
;.MACRO LOAD_CONST  
;LDI @0, LOW(@2)
;LDI @1, HIGH(@2)
;.ENDMACRO
;
;.equ Digits_P = PORTB  ; .equ is like #define in C:
;.equ Segments_P = PORTD
;
;LDI R20, $35
;LDI R21, $6
;LDI R18, 1
;LOAD_CONST R16,R17,1000
;STS 0x60, R16
;STS 0x61, R17
;LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie
;LDI R24, 0x3f ;"0"
;LDI R25, 0x10 ;4cyfra
;LDI R26, 0x1e
;
;OUT DDRD, R23
;OUT DDRB, R26
;
;Zero: OUT Segments_P, R24
;	OUT Digits_P, R25
;	LDI R25, 0x8 ;3cyfra
;	RCALL DelayInMs 
;	OUT Segments_P, R24
;	OUT Digits_P, R25
;	LDI R25, 0x4 ;2 cyfra
;	RCALL DelayInMs 
;	OUT Segments_P, R24
;	OUT Digits_P, R25
;	LDI R25, 0x2 ; 1 cyfra
;	RCALL DelayInMs
;	OUT Segments_P, R24
;	OUT Digits_P, R25
;	LDI R25, 0x10 ;4cyfra
;	RCALL DelayInMs
;RJMP Zero
;
;DelayInMs:
;	RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP DelayInMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: 
;	LDS R16, 0x60
;	LDS R17, 0x61
;	RET
;
;		DelayOneMs:
;			PUSH R21
;			PUSH R20
;
;			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;			NOP
;			BRBS 1, Loop2
;			RJMP Loop1
;
;			Loop2: DEC R21
;			BRBS 2, End 
;			RJMP Loop1
;
;			End: 
;			POP R20
;			POP R21
;			CLN
;			RET
;
;cw30b
;.MACRO LOAD_CONST  
;LDI @0, LOW(@2)
;LDI @1, HIGH(@2)
;.ENDMACRO
;
;.equ Digits_P = PORTB  ; .equ is like #define in C:
;.equ Segments_P = PORTD
;
;LDI R20, $35
;LDI R21, $6
;LDI R18, 1
;LOAD_CONST R16,R17,1000
;STS 0x60, R16
;STS 0x61, R17
;LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie
;LDI R24, 0x3f ;"0"
;LDI R25, 0x10 ;4cyfra
;LDI R26, 0x1e
;
;OUT DDRD, R23
;OUT DDRB, R26
;Zero: OUT Segments_P, R24
;OUT Digits_P, R25
;LDI R25, 0x8 ;3cyfra
;RCALL DelayInMs 
;OUT Segments_P, R24
;OUT Digits_P, R25
;LDI R25, 0x4 ;2 cyfra
;RCALL DelayInMs 
;OUT Segments_P, R24
;OUT Digits_P, R25
;LDI R25, 0x2 ; 1 cyfra
;RCALL DelayInMs
;OUT Segments_P, R24
;OUT Digits_P, R25
;LDI R25, 0x10 ;4cyfra
;RCALL DelayInMs
;RJMP Zero
;
;DelayInMs:
;	RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP DelayInMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: 
;	LDS R16, 0x60
;	LDS R17, 0x61
;	RET
;
;		DelayOneMs:
;			PUSH R21
;			PUSH R20
;
;			Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;			NOP
;			BRBS 1, Loop2
;			RJMP Loop1
;
;			Loop2: DEC R21
;			BRBS 2, End 
;			RJMP Loop1
;
;			End: 
;			POP R20
;			POP R21
;			CLN
;			RET
;
;cw30a
;.MACRO LOAD_CONST 
;LDI @0, LOW(@2)
;LDI @1, HIGH(@2)
;.ENDMACRO
;
;LDI R20, $35
;LDI R21, $6
;LDI R18, 1
;LOAD_CONST R16,R17,250
;STS 0x60, R16
;STS 0x61, R17
;LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie
;LDI R24, 0x3f ;"0"
;LDI R25, 0x10 ;4cyfra
;LDI R26, 0x1e
;
;OUT DDRD, R23
;OUT DDRB, R26
;Zero: OUT PORTD, R24
;OUT PORTB, R25
;LDI R25, 0x8 ;3cyfra
;RCALL DelayInMs 
;OUT PORTD, R24
;OUT PORTB, R25
;LDI R25, 0x4 ;2 cyfra
;RCALL DelayInMs 
;OUT PORTD, R24
;OUT PORTB, R25
;LDI R25, 0x2 ; 1 cyfra
;RCALL DelayInMs
;OUT PORTD, R24
;OUT PORTB, R25
;LDI R25, 0x10 ;4cyfra
;RCALL DelayInMs
;RJMP Zero
;
;DelayInMs:
;	RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP DelayInMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: 
;	LDS R16, 0x60
;	LDS R17, 0x61
;	RET
;
;	DelayOneMs:
;		PUSH R21
;		PUSH R20
;
;		Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;		NOP
;		BRBS 1, Loop2
;		RJMP Loop1
;
;		Loop2: DEC R21
;		BRBS 2, End 
;		RJMP Loop1
;
;		End: 
;		POP R20
;		POP R21
;		CLN
;		RET
;
;cw29
;.MACRO LOAD_CONST 
;LDI @0, LOW(@2)
;LDI @1, HIGH(@2)
;.ENDMACRO
;
;LDI R20, $35
;LDI R21, $6
;LDI R18, 1
;LOAD_CONST R16,R17,250
;STS 0x60, R16
;STS 0x61, R17
;LDI R23, 0x7f ;ustawienie 7 pinów jako wejœcie
;LDI R24, 0x3f ;"0"
;LDI R25, 0x6 ;"1"
;LDI R26, 0x2
;
;OUT DDRD, R23
;OUT DDRB, R26
;OUT PORTB, R26
;Zero: OUT PORTD, R24
;RCALL DelayInMs 
;OUT PORTD, R25
;RCALL DelayInMs 
;RJMP Zero
;
;DelayInMs:
;	RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP DelayInMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: 
;	LDS R16, 0x60
;	LDS R17, 0x61
;	RET
;
;	DelayOneMs:
;		PUSH R21
;		PUSH R20
;
;		Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;		NOP
;		BRBS 1, Loop2
;		RJMP Loop1
;
;		Loop2: DEC R21
;		BRBS 2, End 
;		RJMP Loop1
;
;		End: 
;		POP R20
;		POP R21
;		CLN
;		RET
;
;cw28
;LDI R18, $1e
;LDI R19, $0
;OUT DDRB, R18
;OUT PORTB, R18
;OUT PORTB, R19
;RJMP 3

;cw27bcw
;.MACRO LOAD_CONST 
;LDI @0, LOW(@2)
;LDI @1, HIGH(@2)
;.ENDMACRO
;
;LDI R20, $35
;LDI R21, $6
;LOAD_CONST R16,R17,257
;LDI R18, 1
;RCALL DelayInMs 
;NOP
;RJMP 0
;
;DelayInMs:
;	RCALL DelayOneMs 
;	
;	Timer: CLN 
;	CLC
;	SBC R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP DelayInMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: RET
;
;	DelayOneMs:
;		PUSH R21
;		PUSH R20
;
;		Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;		NOP
;		BRBS 1, Loop2
;		RJMP Loop1
;
;		Loop2: DEC R21
;		BRBS 2, End 
;		RJMP Loop1
;
;		End: 
;		POP R20
;		POP R21
;		CLN
;		RET
;1ms ~~ 999.63 us

;cw27b
;LDI R20, $35
;LDI R21, $6
;LDI R16, 1
;LDI R17, 0
;LDI R18, 1
;RCALL DelayInMs 
;NOP
;RJMP 0
;
;DelayInMs:
;	RCALL DelayOneMs 
;
;	PUSH R17
;	PUSH R16
;
;	Timer: CLN 
;	POP R16
;	POP R17
;	SUB R16,R18
;	BRBS 1, OldTimer
;	BRBS 0, OldTimer
;	RJMP DelayInMs
;
;	OldTimer: CLN 
;	SUB R17,R18
;	BRBS 2, DelayEnd
;	RJMP Timer
;
;
;DelayEnd: RET
;
;	DelayOneMs:
;		PUSH R21
;		PUSH R20
;
;		Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;		NOP
;		BRBS 1, Loop2
;		RJMP Loop1
;
;		Loop2: DEC R21
;		BRBS 2, End 
;		RJMP Loop1
;
;		End: 
;		POP R20
;		POP R21
;		CLN
;		RET
;1ms ~~ 999.63 us

;cw27a
;LDI R20, $37
;LDI R21, $7
;LDI R22, 2
;RCALL DelayInMs 
;NOP
;RJMP 0
;
;DelayInMs:
;	RCALL DelayOneMs 
;
;	Timer: DEC R22
;	BRBS 1, DelayEnd
;	RJMP DelayInMs
;
;DelayEnd: RET
;
;	DelayOneMs:
;		PUSH R21
;		PUSH R20
;
;		Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;		NOP
;		BRBS 1, Loop2
;		RJMP Loop1
;
;		Loop2: DEC R21
;		BRBS 1, End 
;		RJMP Loop1
;
;		End: 
;		POP R20
;		POP R21
;		RET
; 1ms ~~ 999.63 us


;cw26
;LDI R20, $37
;LDI R21, $7
;STS 0x60, R20
;STS 0x61, R21
;RCALL DelayInMs 
;NOP
;RJMP 0
;
;DelayInMs:
;	RCALL DelayOneMs 
;
;	LDI R20, 1
;	Timer: DEC R20
;	BRBS 1, DelayEnd
;	;STS 0x60, R20
;	RJMP DelayInMs
;
;DelayEnd: RET
;
;	DelayOneMs:
;		LDS R20 , 0x60
;		LDS R21 , 0x61
;		Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;		NOP
;		BRBS 1, Loop2
;		RJMP Loop1
;
;		Loop2: DEC R21
;		BRBS 1, End 
;		RJMP Loop1
;
;		End: RET
; 1ms ~~ 999.63 us

;cw25
;LDI R20, 1
;STS 0x60, R20
;RCALL DelayInMs 
;NOP
;RJMP 0
;
;DelayInMs:
;	LDI R20, $37
;	LDI R21, $7
;	RCALL DelayOneMs 
;
;	LDS R20, 0x60
;	Timer: DEC R20
;	BRBS 1, DelayEnd
;	STS 0x60, R20
;	RJMP DelayInMs
;
;DelayEnd: RET
;	DelayOneMs:
;
;		Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;		NOP
;		BRBS 1, Loop2
;		RJMP Loop1
;
;		Loop2: DEC R21
;		BRBS 1, End 
;		RJMP Loop1
;
;		End: RET
; 1ms ~~ 999.88 us

;cw24
;RCALL DelayInMs 
;NOP
;RJMP 0
;
;DelayInMs:
;	LDI R20, $39
;	LDI R21, $7
;
;	RCALL DelayOneMs 
;RET
;	DelayOneMs:
;		;LDI R22, 1 ; ms delay
;		Loop1: DEC R20 ;DEC nie wywo³uje flagi przeniesienia
;		NOP
;		BRBS 1, Loop2
;		RJMP Loop1
;
;		Loop2: DEC R21
;		BRBS 1, End ; Timer
;		RJMP Loop1
;
;		;Timer: DEC R22
;		;BRBS 1, End
;		;RJMP Loop1
;
;		End: RET

;cw23
;LDI R22, 1 ; ms delay
;RCALL DelayInMs 
;RJMP 0

;DelayInMs:
;LDI R20, $39
;LDI R21, $c
;LDI R23, 1

;RCALL DelayOneMs 
;RET

;	DelayOneMs:
;	LDI R22, 1
;	Loop1: SBC R20,R23
;	NOP
;	BRBS 0, Loop2
;	RJMP Loop1
;
;	Loop2: SBC R21,R23
;	BRBS 0, Timer
;	RJMP Loop1
;
;	Timer: DEC R22
;	BRBS 1, End
;	RJMP Loop1
;
;	End: RET

;cw22
;LDI R22, 1 ; ms delay
;LDI R20, $39
;LDI R21, $c
;RCALL DelayInMs 
;RJMP 0

;DelayInMs:

;LDI R23, 1

;Loop1: SBC R20,R23
;NOP
;BRBS 0, Loop2
;RJMP Loop1

;Loop2: SBC R21,R23
;BRBS 0, Timer
;RJMP Loop1

;Timer: DEC R22
;BRBS 1, End
;RJMP Loop1

;End: RET

;cw21

;Start:
;LDI R20,5
;RCALL Loop 
;RJMP Start

;Loop: 
;DEC R20
;BRBS 1,End
;RJMP Loop
;End: RET


;cw20

;MainLoop:
;RCALL DelayNCycles ;
;RJMP MainLoop

;DelayNCycles: ;zwyk³a etykieta
;NOP
;NOP
;NOP
;RET ;powrót do miejsca wywo³ania
;1 cykl - 12.5 us ; czas podprogramu - 10 cykli

;cw19

;LDI R22, 1
;LDI R20, $39
;LDI R21, $c
;LDI R23, 1

;Loop1: SBC R20,R23
;NOP
;BRBS 0, Loop2
;RJMP Loop1

;Loop2: SBC R21,R23
;BRBS 0, Timer
;RJMP Loop1

;Timer: DEC R22
;BRBS 1, End
;RJMP Loop1

;End: NOP
;StopWatch = 1ms *R22 - (999,63us)


;cw18

;LDI R22, 1
;LDI R20, $c6
;LDI R21, $f3
;LDI R23, 1
;
;Loop1: ADC R20,R23
;NOP
;BRBS 0, Loop2
;RJMP Loop1
;
;Loop2: ADC R21,R23
;BRBS 0, Timer
;RJMP Loop1
;
;Timer: DEC R22
;BRBS 1, End
;RJMP Loop1

;End: NOP
;StopWatch = 1ms *R22 - (999,63us)

;cw17
;LDI R22, 2
;LDI R20, 96
;LDI R21, 16

;Timer:

;Loop1: DEC R20
;BRBS 1, Jump1

;Loop2: DEC R21
;NOP
;BRBS 1, Jump2
;RJMP Loop2

;Jump2: LDI R21, 16
;RJMP Loop1
;Jump1: LDI R20, 96
;LDI R21, 16
;DEC R21
;LDI R21, 16
;DEC R22
;BRBS 1, End
;RJMP Loop1

;RJMP Timer
;End: NOP
;StopWatch = 1ms *R22 - (999us)

;cw16
;LDI R20, 96
;LDI R21, 16
;Loop1: DEC R20
;BRBS 1, End
;Loop2: DEC R21
;NOP
;BRBS 1, Jump1
;RJMP Loop2
;Jump1: RJMP 1
;End:NOP
;Cycles = 5*R20*R21 + 4*R20 + 3

;cw15
;LDI R20, 119
;LDI R21, 16
;Loop1: DEC R20
;NOP
;BRBS 1, End
;Loop2: DEC R21
;NOP
;BRBS 1, Jump1
;RJMP Loop2
;Jump1: RJMP 1
;End:NOP
;Cycles = 5*R20*R21 + 4*R20 + 3

;cw14
;LDI R20, 50
;LDI R21, 10
;Loop1: DEC R20
;BRBS 1, End
;Loop2: DEC R21
;NOP
;BRBS 1, Jump1
;RJMP Loop2
;Jump1: RJMP 1
;End:

;cw13
;NOP
;NOP
;NOP
;NOP
;NOP
;LDI R20, 5
;Loop: DEC R20
;NOP
;BRBS 1,End
;RJMP Loop
;End: RJMP 0
;b)c)20 cykli potrzebuje, Cycles = R20*4, 

;cw12
;LDI R20, $5
;Loop: DEC R20
;BRBS 1,End
;RJMP Loop
;End: NOP

;cw11
;LDI R20, $5
;LDI R21, $1
;Loop: SUB R20, R21
;RJMP Loop

;cw10
;LDI R20, $5
;LDI R21, $1
;SUB R20, R21
;RJMP 2

;cw9
;NOP
;NOP
;RJMP 4
;NOP
;NOP
;NOP
;0 ffd - 1 ffe - 2 fff - 3 000 - 4 001

;cw8
;NOP
;NOP
;RJMP 1
;NOP
;NOP
;NOP

;cw7
;LDI R20, 1
;LDI R21, 2
;SBC R20, R21

;cw6
;LDI R20, $2c
;LDI R21, $1
;LDI R22, $90
;LDI R23, $1
;ADC R20, R22
;ADC R21, R23

;cw5
;LDI R20,100
;LDI R21,200
;ADC R20,R21
;LDI R21,0
;ADC R21,R21

;cw4
;LDI R16, 100
;LDI R17, 200
;ADD R16, R17
;SUB R17, R16
;zapala flagê

;cw3
;LDI R16, 100
;LDI R17, 200
;ADD R16, R17
;jest to reszta z dzielenia

;cw2
;LDI R16, 3
;LDI R17, 1
;MOV R0, R16
;SUB R0, R17 
;SUB R0, R17
;SUB R0, R17

; cw1
;LDI R20, 14
;LDI R21, 17
;MOV R0, R20
;MOV R1, R21
;ADD R0, R1

