//* example */

.MACRO LOAD_CONST
ldi @0, low(@2)
ldi @1, high(@2)

.ENDMACRO

.MACRO SET_DIGIT
	ldi r17, (2<<@0)
	out PORTB, r17

	rcall DigitsTo7segCode
	out PORTD,r16
	rcall DelayInMs
.ENDMACRO


.cseg
.org 0 rjmp _main
.org 4 rjmp _timer_isr
.org 0xb rjmp _pcint_isr


.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Dig0=R5 ; Digits temps
.def Dig1=R6 ;
.def Dig2=R7 ;
.def Dig3=R8 ;



.equ Digits_P = PORTB  ; .equ is like #define in C:
.equ Segments_P = PORTD

_timer_isr:
	rcall NumberToDigits
	clr PulseEdgeCtrL
	clr PulseEdgeCtrH
reti

_pcint_isr:
	add PulseEdgeCtrL, r2
	adc PulseEdgeCtrH, r3
	clc
reti

_reg_init:
//global
sei
//timer1 init
	ldi r16, 0b1100
	out TCCR1B, r16 ; ctc, prescaler 256

	ldi r16, (1<<6)
	out TIMSK, r16

	ldi r16, LOW(15625) //output compare
	out  OCR1AL, r16
	ldi r16, HIGH(15625)
	out OCR1AH, r16
//external init
	ldi r16, (1<<5)
	out gimsk, r16

	ldi r16,0b1
	out	PCMSK0, r16
//display
	ldi r16, 0x1e
	out DDRB, r16 // 4 cyfry
	ldi r16, 0x7f
	out DDRD, r16 //7 segmentow


ret




_main:

	rcall OneMsLoop
	ldi r16,1
	mov r2,r16
	clr r3
	rcall _reg_init

	MainLoop:
		mov r16, Dig0
		SET_DIGIT 0
		mov r16, Dig1
		SET_DIGIT 1
		mov r16, Dig2
		SET_DIGIT 2
		mov r16, Dig3
		SET_DIGIT 3

	rjmp MainLoop
reti


NumberToDigits:
	LOAD_CONST r30, r31, 1000
	//thousands
	Sub0:
	cp PulseEdgeCtrL, r30
	cpc PulseEdgeCtrH, r31
	brlo Res0

	sub PulseEdgeCtrL, r30
	sbc PulseEdgeCtrH, r31
	inc r29
	rjmp Sub0

	Res0:
	mov Dig0, r29
	clr r29
	//hundreds
	LOAD_CONST r30, r31, 100
	Sub1:
	cp PulseEdgeCtrL, r30
	cpc PulseEdgeCtrH, r31
	brlo Res1

	sub PulseEdgeCtrL, r30
	sbc PulseEdgeCtrH, r31
	inc r29
	rjmp Sub1

	Res1:
	mov Dig1, r29
	clr r29

	//tens
	LOAD_CONST r30,r31,10
	Sub2:
	cp PulseEdgeCtrL, r30
	cpc PulseEdgeCtrH,r31
	brlo Res2

	sub PulseEdgeCtrL,r30
	sbc PulseEdgeCtrH, r31
	inc r29
	rjmp Sub2

	Res2:
	mov Dig2, r29
	clr r29
	//ones
	Res3:
	mov Dig3, PulseEdgeCtrL

ret
		Table: .db 0x3f, 0x6, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x7, 0x7f, 0x6f

DigitsTo7segCode:

	clr r29
	ldi r30, LOW(Table<<1)
	ldi r31, HIGH(Table<<1)

	add r30, r16
	adc r31, r29

	lpm r16, Z

ret

Delay:

ret

OneMsLoop:
	LOAD_CONST r30,r31,2350

	Timer1: dec r30
	brbs 1, Timer2
	rjmp Timer1

	Timer2: dec r31
	brbs 1, Endl
	brbs 2, Endl
	rjmp Timer1

	Endl:
ret

DelayInMs:

	PUSH R16
	PUSH R17
	LOAD_CONST R16,R17,5
	OneMs: RCALL DelayOneMs 
	
	Timer: CLN 
	CLC
	SBC R16,R2
	BRBS 1, OldTimer
	BRBS 0, OldTimer
	RJMP OneMs

	OldTimer: CLN 
	SUB R17,R2
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

