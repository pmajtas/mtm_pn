/*
 * AVR_Meter.asm
 *
 *  Created: 10/2/2019 2:39:02 PM
 *   Author: student
 */ 

 ;
; AssemblerApplication1.asm
;
; Created: 2019-10-01 20:15:00
; Author : Moj

;cw28


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
;		Loop1: DEC R20 ;DEC nie wywo�uje flagi przeniesienia
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
;		Loop1: DEC R20 ;DEC nie wywo�uje flagi przeniesienia
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
;		Loop1: DEC R20 ;DEC nie wywo�uje flagi przeniesienia
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
;		Loop1: DEC R20 ;DEC nie wywo�uje flagi przeniesienia
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
;		Loop1: DEC R20 ;DEC nie wywo�uje flagi przeniesienia
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

;DelayNCycles: ;zwyk�a etykieta
;NOP
;NOP
;NOP
;RET ;powr�t do miejsca wywo�ania
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
;zapala flag�

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

