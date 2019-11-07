/*
 * AvrThreats.asm
 *
 *  Created: 10/30/2019 1:14:09 PM
 *   Author: student
 */ 


 .ORG	0			RJMP	Start
 .ORG	OC1Aaddr	RJMP	TimerISR
 
 TimerISR:
		INC		R20
		ANDI	R20, 1

		CPI		R20, 1
		BRNE	TimerISRb

		POP		R2 ;high
		POP		R1 ;low

		PUSH	R3
		PUSH	R4
		NOP			;wyrownanie czestotliwosci na brne
		NOP

		RETI

TimerISRb:
		POP		R4 ;high
		POP		R3 ;low

		PUSH	R1
		PUSH	R2

		RETI

 Start:
		LDI		R17, 30
		OUT		DDRB, R17
		LDI		R17, $FF
		OUT		DDRD, R17

		LDI		R17, $FF
		OUT		PORTD, R17

		LDI		R17, 12
		OUT		TCCR1B, R17
		LDI		R17, 0
		OUT		TCCR1A, R17
		LDI		R17, $00
		OUT		OCR1AH, R17
		LDI		R17, $04
		OUT		OCR1AL, R17
		LDI		R17, $C0
		OUT		TIMSK, R17

		SEI

		LDI		R16, HIGH(LoopB)
		MOV		R4, R16
		PUSH	R16
		LDI		R16, LOW(LoopB)
		MOV		R3, R16
		PUSH	R16

		CLR		R20
		CLR		R24
		CLR		R25
		CLR		R26
		CLR		R27
		CLR		R28
		CLR		R29

LoopA:
		ADIW	R25:R24, 1
		CPI		R25, 25
		BRNE	LoopAd

		CLR		R24
		CLR		R25
		LDI		R17, 2
		IN		R18, PORTB
		EOR		R18, R17
		OUT		PORTB, R18
LoopAd:	
		INC		R28
		BRNE	LoopAd

		RJMP	LoopA

LoopB:
		ADIW	R27:R26, 1
		CPI		R27, 10
		BRNE	LoopBd

		CLR		R27
		CLR		R28
		LDI		R17, 4
		IN		R18, PORTB
		EOR		R18, R17
		OUT		PORTB, R18
LoopBd:	
		INC		R29
		BRNE	LoopBd

		RJMP	LoopB
