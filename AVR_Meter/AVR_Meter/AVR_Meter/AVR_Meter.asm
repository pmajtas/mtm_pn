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


;cw16
LDI R20, 99
LDI R21, 16
Loop1: DEC R20
BRBS 1, End
Loop2: DEC R21
NOP
BRBS 1, Jump1
RJMP Loop2
Jump1: RJMP 1
End:NOP
;Cycles = 5*R20*R21 + 4*R20 + 3

;cw15
;LDI R20, 119
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
;20 cykli potrzebuje, Cycles = R20*4, 

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

