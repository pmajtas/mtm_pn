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

