;
; AVR_Thread.asm
;
; Created: 2019-11-04 14:44:06
; Author : Moj
;
/*
.MACRO LOAD_CONST  
 ldi  @0,low(@2)
 ldi  @1,high(@2)
.ENDMACRO

.equ DigitsPort = PORTB
.equ SegmentsPort = PORTD
.def CurrentThread=R17
.def ThreadA_LSB = R18
.def ThreadA_MSB = R19
.def ThreadB_LSB = R20
.def ThreadB_MSB = R21
.def Sreg_A = R1
.def Sreg_B = R2
.def Sreg_Glob = R3

.cseg
.org	 0      rjmp	_main
.org 4	rjmp  _Timer_ISR

_Timer_ISR:
	IN Sreg_Glob, SREG
	PUSH R16
	LDI R16,1
	CP CurrentThread, R16
	POP R16
	BREQ Case_B
	Case_A:
		MOV Sreg_A, Sreg_Glob
		LDI R16, 0x01
		EOR CurrentThread, R16
		OUT SREG, Sreg_B
		
		POP R16
		MOV ThreadA_MSB, R16
		POP R16
		MOV ThreadA_LSB, R16
		PUSH ThreadB_LSB
		PUSH ThreadB_MSB
		RJMP Stop_Interrupt		
	Case_B:
		MOV Sreg_B, Sreg_Glob
		LDI R16, 0x01
		EOR CurrentThread, R16
		OUT SREG, Sreg_A

		POP R16
		MOV ThreadB_MSB, R16
		POP R16
		MOV ThreadB_LSB, R16
		PUSH ThreadA_LSB
		PUSH ThreadA_MSB
	Stop_Interrupt:
		NOP
  reti

_main: 
	LDI ThreadA_LSB, LOW(ThreadA)
	LDI ThreadA_MSB, HIGH(ThreadA)
	LDI ThreadB_LSB, LOW(ThreadB)
	LDI ThreadB_MSB, HIGH(ThreadB)
	CLR CurrentThread
    ; * Initialisations *
	;--- Timer1 --- CTC with 1 prescaller
	LDI R16, (1<<3)|(1<<0)
	OUT TCCR1B, R16

	LDI R16, HIGH(100)
	OUT OCR1AH, R16

	LDI R16, LOW(100)
	OUT OCR1AL, R16

	LDI R16, 1<<OCIE1A
	OUT TIMSK, R16
	; --- enable global interrupts
	SEI
	;---  Display  --- 
	LDI R16, 0x06
	OUT DDRB, R16
	LDI R16, 0xFF
	OUT DDRD, R16
	LDI R16, 0x3f
	OUT SegmentsPort, R16

ThreadA:
	IN R22, DigitsPort
	LDI R23, 0b010
	EOR R22, R23
	OUT DigitsPort, R22
			
	ldi r26, 6
	LOAD_CONST R28,R29,32000
	L1:
	L_A:			
		SBIW R29:R28,1 
		BRNE L_A
		clz
		dec r26
		cpi r26, 0
		brne L1

RJMP ThreadA

ThreadB:
	IN R22, DigitsPort
	LDI R23, 0b100
	EOR R22, R23
	;LDI R16, 0x06
	;OUT SegmentsPort, R16
	OUT DigitsPort, R22
	ldi r27, 4

	LOAD_CONST R30,R31,32000
	L2:
	L_B:		
		SBIW R31:R30,1
		BRNE L_B
		clz
		dec r27
		cpi r27,0
		brne L2

RJMP ThreadB
*/

.macro LOAD_CONST
ldi @0, low(@2)
ldi @1, high(@2)
.endmacro

.def GlobSreg = r2
.def SregA = r0
.def SregB = r1
.def CurrentThread = r20
.def ThreadA_LSB = r21
.def ThreadA_MSB = r22
.def ThreadB_LSB = r23
.def ThreadB_MSB = r24

.cseg
.org 0 rjmp _main
.org OC1Aaddr rjmp _ISR

_ISR:
	in r2, sreg
	cpi CurrentThread, 1
	breq ThrB

	mov r0,r2

	ldi CurrentThread, 1 //powrót z A
	pop ThreadA_MSB
	pop ThreadA_LSB

	push ThreadB_LSB
	push ThreadB_MSB
	
	out sreg, r1

	rjmp end

	ThrB:
	clz
	mov r1,r2

	pop ThreadB_MSB
	pop ThreadB_LSB

	push ThreadA_LSB
	push ThreadA_MSB
	
	clr CurrentThread

	out sreg, r0
	end:
reti

_main:
	//Timer
	ldi r16, ((1<<OCIE1A)|(1<<TOIE1))
	out timsk, r16

	ldi r16, 0b1001
	out tccr1b, r16

	ldi r16, high(100)
	out ocr1ah, r16

	ldi r16, low(100)
	out ocr1al, r16

	clr CurrentThread

	ldi r16, 0b110
	out ddrb, r16

	ldi r16, 0x7f
	out ddrd, r16

	ldi r16, 0x3f
	out portd, r16

	sei

	ldi ThreadA_LSB, low(ThreadA)
	ldi ThreadA_MSB, high(ThreadA)

	ldi ThreadB_LSB, low(ThreadB)
	ldi ThreadB_MSB, high(ThreadB)

	ThreadA:

		in r17, portb
		ldi r18, 0b10
		eor r17,r18
		out portb, r17

		ldi r19, 2
		LOAD_CONST r28,r29, 32000

		L1:
		L11:
		sbiw r29:r28, 1
		brne L11
		clz
		dec r19
		cpi r19,0
		brne L1

	rjmp ThreadA

	ThreadB:

		in r26, portb
		ldi r18, 0b100
		eor r26,r18
		out portb, r26

		ldi r25, 4
		LOAD_CONST r30,r31, 32000

		L2:
		L22:
		sbiw r31:r30, 1
		brne L22
		clz
		dec r25
		cpi r25,0
		brne L2

	rjmp ThreadB

reti


/*
;cw5

.def CtrA = R0
.def CtrB = R1

.def CurrentThread=R20
.def ThreadA_LSB = R21
.def ThreadA_MSB = R22
.def ThreadB_LSB = R23
.def ThreadB_MSB = R24

.cseg
.org 0 rjmp _main
.org OC1Aaddr rjmp _ISR


_ISR:
	

	cpi CurrentThread , 1
	breq ThB

	in r1, sreg
	

	pop ThreadA_MSB ;push najpierw lsb adresu, potem msb
	pop ThreadA_LSB ;pop odwrotnie


	push ThreadB_LSB
	push ThreadB_MSB
	
	ldi CurrentThread, 1

	out sreg, r2
	rjmp end

	ThB:

	in r2,sreg
	

	pop ThreadB_MSB
	pop ThreadB_LSB


	push ThreadA_LSB
	push ThreadA_MSB

	clr CurrentThread
	out sreg, r1
	end:
reti


_main:

	ldi r16,  0b1100
	out tccr1b, r16

	ldi r16, ((1<<OCIE1A)|(1<<TOIE1))
	out timsk, r16
	
	ldi r16, high(100)
	out ocr1ah, r16

	ldi r16, low(100)
	out ocr1al , r16

	sei
	
	ldi r16, 0b110
	out ddrb , r16

	ldi r16, 0x7f
	out ddrd, r16

	ldi r17, 0x3f
	out portd, r17

	clr CurrentThread
	ldi r16, 1

	ldi ThreadA_LSB, low(ThreadA)
	ldi ThreadA_MSB, high(ThreadA)

	ldi ThreadB_LSB, low(ThreadB)
	ldi ThreadB_MSB, high(ThreadB)

ThreadA:
		

MainLoopA:
	ldi r17, 2
	in r18, portb
	eor r18,r17
	out portb, r18

	ldi r16, 8

	ldi r28, low(32000)
	ldi r29, high(32000)

	L1:dec r16
	L11:
	sbiw r29:r28, 1
	brne L11
	clz
	cpi r16,0
	brne L1
	

    rjmp MainLoopA


ThreadB:	

MainLoopB:

	ldi r17, 4
	in r18, portb
	eor r18,r17
	out portb, r18

	ldi r19, 13

	ldi r26, low(32000)
	ldi r27, high(32000)

	L2: dec r19
	L21: 
	sbiw r27:r26, 1
	brne L21
	clc
	cpi r19,0
	brne L2

	
    rjmp MainLoopB
*/

/*
;cw4

.def CtrA = R0
.def CtrB = R1

.def CurrentThread=R20
.def ThreadA_LSB = R21
.def ThreadA_MSB = R22
.def ThreadB_LSB = R23
.def ThreadB_MSB = R24

.cseg
.org 0 rjmp _main
.org OC1Aaddr rjmp _ISR


_ISR:
	pop r19
	pop r19

	mov r19, CurrentThread
	and r19, r16
	cpi r19 , 0
	breq ThA

	push ThreadB_LSB ;najpierw lsb adresu, potem msb
	push ThreadB_MSB
	rjmp end

	ThA:
	push ThreadA_LSB
	push ThreadA_MSB

	end:
reti


_main:
	ldi r16,  0b1001 
	out tccr1b, r16

	ldi r16, (1<<OCIE1A)
	out timsk, r16
	
	ldi r16, 100
	out ocr1al , r16

	sei
	
	clr CurrentThread
	ldi r16, 1

ThreadA:
	

	ldi ThreadA_LSB, low(ThreadA)
	ldi ThreadA_MSB, high(ThreadA)

	ldi ThreadB_LSB, low(ThreadB)
	ldi ThreadB_MSB, high(ThreadB)

	inc CurrentThread

MainLoopA:

	inc CtrA

    rjmp MainLoopA


ThreadB:

	ldi ThreadA_LSB, low(ThreadA)
	ldi ThreadA_MSB, high(ThreadA)

	ldi ThreadB_LSB, low(ThreadB)
	ldi ThreadB_MSB, high(ThreadB)

	clr CurrentThread

MainLoopB:

    inc CtrB
	
    rjmp MainLoopB */

/*
;cw3
.def CurrentThread=R20
.def ThreadA_LSB = R21
.def ThreadA_MSB = R22

.cseg
.org 0 rjmp ThreadA
.org OC1Aaddr rjmp ThreadB


ThreadB:
	pop r19
	pop r19

	mov r19, CurrentThread
	and r19, r16
	sub CurrentThread, r19

	push ThreadA_LSB ;najpierw lsb adresu, potem msb
	push ThreadA_MSB
reti


ThreadA:
	ldi r16,  0b1001 
	out tccr1b, r16

	ldi r16, (1<<OCIE1A)
	out timsk, r16
	
	ldi r16, 100
	out ocr1al , r16

	sei
	
	clr CurrentThread
	ldi r16, 1

	ldi ThreadA_LSB, low(ThreadA)
	ldi ThreadA_MSB, high(ThreadA)
MainLoop:

    NOP
	NOP
	NOP
	NOP
	NOP
	inc CurrentThread

    rjmp MainLoop*/
	;dzia³a asynchronicznie, wraca po obs³udze przerwania do tego samego miejsca gdzie nast¹pi³o wywo³anie 
	;przy czym wywo³anie nastêpuje w ró¿nych miejscach (co 100 cykli)

	/*
;cw2

.def CurrentThread=R20

.cseg
.org 0 rjmp ThreadA
.org OC1Aaddr rjmp ThreadB


ThreadB:
	mov r19, CurrentThread
	and r19, r16
	sub CurrentThread, r19
reti


ThreadA:
	ldi r16,  0b1001 
	out tccr1b, r16

	ldi r16, (1<<OCIE1A)
	out timsk, r16
	
	ldi r16, 100
	out ocr1al , r16

	sei
	
	clr CurrentThread
	ldi r16, 1
MainLoop:

    NOP
	NOP
	NOP
	NOP
	NOP
	inc CurrentThread

    rjmp MainLoop */



/*
;cw1
.cseg
.org 0 rjmp ThreadA
.org OC1Aaddr rjmp ThreadB


ThreadB:
	NOP
reti


ThreadA:
	ldi r16,  0b1001 
	out tccr1b, r16

	ldi r16, (1<<OCIE1A)
	out timsk, r16
	
	ldi r16, 100
	out ocr1al , r16

	sei

MainLoop:

    NOP
	NOP
	NOP
	NOP
	NOP

    rjmp MainLoop */
