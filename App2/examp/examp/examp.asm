 ;### MACROS & defs (.equ)###

; Macro LOAD_CONST loads given registers with immediate value, example: LOAD_CONST  R16,R17 1234 
.MACRO LOAD_CONST  
 ldi @0, low(@2)
 ldi @1, high(@2)
.ENDMACRO 

/*** Display ***/
.equ DigitsPort    =portb         ; TBD
.equ SegmentsPort        =portd   ; TBD
;.equ DisplayRefreshPeriod   ; TBD

; SET_DIGIT diplay digit of a number given in macro argument, example: SET_DIGIT 2
.MACRO SET_DIGIT  
 ldi r21, (2<<@0)
 out portb, r21

 mov r16, dig_@0

 rcall DigitTo7segCode
 out portd, r16

 rcall DelayInMs
.ENDMACRO 

; ### GLOBAL VARIABLES ###

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Dig_0=R2
.def Dig_1=R3
.def Dig_2=R4
.def Dig_3=R5

; ### INTERRUPT VECTORS ###
.cseg		     ; segment pami�ci kodu programu 

.org	 0      rjmp	_main	 ; skok do programu g��wnego
.org OC1Aaddr	rjmp _Timer_ISR ; TBD
.org PCIBaddr   rjmp _ExtInt_ISR ; TBD ; skok do procedury obs�ugi przerwania zenetrznego 

; ### INTERRUPT SEERVICE ROUTINES ###

_ExtInt_ISR: 	 ; procedura obs�ugi przerwania zewnetrznego

 push r16
 in r16, sreg
 push r16
 clr r7
 add PulseEdgeCtrL, r6
 adc PulseEdgeCtrH, r7
 clc

 pop r16
 out sreg, r16
 pop r16

reti   ; powr�t z procedury obs�ugi przerwania (reti zamiast ret)      

_Timer_ISR:
    push R16
    push R17
    push R18
    push R19

    rcall _NumberToDigits
	clr PulseEdgeCtrL
	clr PulseEdgeCtrH

	pop R19
    pop R18
    pop R17
    pop R16

  reti

; ### MAIN PROGAM ###

_main:
ldi r16, 1
mov r6, r16 
    ; *** Initialisations ***

    ;--- Ext. ints --- PB0
    ldi r16, (1<<PCIE0)
	out gimsk, r16

	ldi r16, 0b1
	out pcmsk0, r16

	;--- Timer1 --- CTC with 256 prescaller
    ldi r16, 0b1100
	out tccr1b, r16

	ldi r16, (1<<OCIE1A)
	out timsk, r16 

	ldi r16, high(15626)
	out OCR1AH, r16
	ldi r16, low(15625)
	out OCR1AL, r16
			
	;---  Display  --- 
	ldi r16, 0x7f
	out ddrd , r16

	ldi r16, 0x1e
	out ddrb, r16
	; --- enable gloabl interrupts
    sei

MainLoop:   ; presents Digit0-3 variables on a Display
			SET_DIGIT 0
			SET_DIGIT 1
			SET_DIGIT 2
			SET_DIGIT 3

			RJMP MainLoop

; ### SUBROUTINES ###

;*** NumberToDigits ***
;converts number to coresponding digits
;input/otput: R16-17/R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divider

; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ; 
.def Dig2=R24 ; 
.def Dig3=R25 ; 

_NumberToDigits:

	push Dig0
	push Dig1
	push Dig2
	push Dig3

	mov r16, PulseEdgeCtrL
	mov r17, PulseEdgeCtrH

	; thousands 
    LOAD_CONST r18, r19, 1000
	rcall _Divide
	mov Dig0, r29
	clr r29

	; hundreads 
    LOAD_CONST r18, r19, 100
	rcall _Divide
	mov Dig1, r29
	clr r29    

	; tens 
    LOAD_CONST r18, r19, 10
	rcall _Divide
	mov Dig2, r29
	clr r29   

	; ones 
    LOAD_CONST r18, r19, 1
	rcall _Divide
	mov Dig3, r29
	clr r29

	; otput result
	mov Dig_0,Dig0
	mov Dig_1,Dig1
	mov Dig_2,Dig2
	mov Dig_3,Dig3

	pop Dig3
	pop Dig2
	pop Dig1
	pop Dig0

	ret

;*** Divide ***
; divide 16-bit nr by 16-bit nr; X/Y -> Qotient,Reminder
; Input/Output: R16-19, Internal R24-25

; inputs
.def XL=R16 ; divident  
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
.def QCtrH=R25

_Divide:push R24 ;save internal variables on stack
        push R25
		

		Sub0:
		cp XL, YL
		cpc XH, YH
		brlo Res

		sub XL, YL
		sbc XH, YH
		inc r29
		rjmp Sub0

		Res:

		pop R25 ; pop internal variables from stack
		pop R24

		ret

; *** DigitTo7segCode ***
; In/Out - R16

Table: .db 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0xff,0x6f

DigitTo7segCode:

push R30
push R31

    ldi r30, low(Table<<1)
	ldi r31, high(Table<<1)

	clr r7
	add r30, r16
	adc r31, r7

	lpm r16, z

pop R31
pop R30

ret

; *** DelayInMs ***
; In: R16,R17
DelayInMs:  
            push R24
			push R25
			LOAD_CONST r24, r25, 5
            L0: rcall OneMsLoop
			sbiw r24:r25, 1
			brne L0

			pop R25
			pop R24

			ret

; *** OneMsLoop ***
OneMsLoop:	
			push R24
			push R25 
			
			LOAD_CONST R24,R25,2000                    

L1:			SBIW R24:R25,1 
			BRNE L1

			pop R25
			pop R24

			ret



