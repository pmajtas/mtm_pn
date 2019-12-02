		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
	
;cw9

CurrentDigit	rn	12

Digit_0 		rn 8
Digit_1 		rn 9
Digit_2 		rn 10
Digit_3 		rn 11

	ldr CurrentDigit, =0
	ldr Digit_0, =0
	ldr Digit_1, =0
	ldr Digit_2, =0
	ldr Digit_3, =0
	
	ldr r5, =IO0DIR ;port0 - digits
	ldr r4, =0xf0000
	str r4, [r5]
	
	ldr r5, =IO1DIR ;port1 - segments
	ldr r4, =0xff0000
	str r4, [r5]
	
	ldr r5, =IO0SET
	ldr r4, =0x80000
	str r4, [r5]
	
	ldr r5, =IO1SET
	ldr r4, =0x3f0000
	str r4, [r5]
	
	ldr r7, =0x80000
main_loop

	;R6 <= DIGIT_X, gdzie X=CURR_DIG (instrukcje cmp i mov)
	cmp CurrentDigit, #0
	moveq r6, Digit_0
	cmp CurrentDigit, #1
	moveq r6, Digit_1
	cmp CurrentDigit, #2
	moveq r6, Digit_2
	cmp CurrentDigit, #3
	moveq r6, Digit_3

	;odczyt Current Digit
	;mov r6, CurrentDigit
	adr r4, Table
	add r4,r4, r6
	ldrb  r6 ,[r4]
	lsl r6, #16
	
	
	
	;zamiana na Seg7Code i wyswietlenie
	ldr r5, =IO1CLR
	ldr r4, =0xff0000
	str r4, [r5]
	ldr r5, =IO1SET
	mov r4, r6
	str r4, [r5]
	
	;wygaszenie cyfr
	ldr r5, =IO0CLR
	ldr r4, =0xf0000
	str r4, [r5]
	
	;zapalenie pierwszej cyfry(skrajna prawa)
	ldr r5, =IO0SET
	mov r4, r7
	str r4, [r5]
	
	;inkrementacja licznika dekadowego
	add Digit_0, Digit_0, #1
	cmp Digit_0, #10
	ldreq Digit_0, =0
	addeq Digit_1, Digit_1, #1
	
	cmp Digit_1, #10
	ldreq Digit_1, =0
	addeq Digit_2, Digit_2, #1
	
	cmp Digit_2, #10
	ldreq Digit_2, =0
	addeq Digit_3, Digit_3, #1
	
	cmp Digit_3, #10
	ldreq Digit_3, =0
	
	
	
	;inkrementacja licznika, przeniesienie do rejestru zapalajacego
	add CurrentDigit, CurrentDigit, #1
	ldr r7, =0x80000
	mov r7,r7, lsr CurrentDigit
	
	;mod4 licznika
	cmp r7, #0x8000
	eoreq r7, #0x88000
	ldreq CurrentDigit, =0
	
	bl ms_delay
	
	b main_loop
	
	
ms_delay	
	ldr r0, =0xa
	ldr r1, =0x3a98
	mul r1, r0, r1
	
ms_loop
	subs r1,r1,#1
	bne ms_loop
	bx lr
	
; tablica kodów siedmiosegmentowych				
Table DCB  0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f

	end



;cw7i8
;
;CurrentDigit	rn	12
;	ldr CurrentDigit, =0x0
;	
;	ldr r5, =IO0DIR ;port0 - digits
;	ldr r4, =0xf0000
;	str r4, [r5]
;	
;	ldr r5, =IO1DIR ;port1 - segments
;	ldr r4, =0xff0000
;	str r4, [r5]
;	
;	ldr r5, =IO0SET
;	ldr r4, =0x80000
;	str r4, [r5]
;	
;	ldr r5, =IO1SET
;	ldr r4, =0x3f0000
;	str r4, [r5]
;	
;	ldr r7, =0x80000
;main_loop
;
;
;
;	;odczyt Current Digit
;	mov r6, CurrentDigit
;	adr r4, Table
;	add r4,r4, r6
;	ldrb  r6 ,[r4]
;	lsl r6, #16
;	
;	;zamiana na Seg7Code i wyswietlenie
;	ldr r5, =IO1CLR
;	ldr r4, =0xff0000
;	str r4, [r5]
;	ldr r5, =IO1SET
;	mov r4, r6
;	str r4, [r5]
;	
	;wygaszenie cyfr
;	ldr r5, =IO0CLR
;	ldr r4, =0xf0000
;	str r4, [r5]
	
	;zapalenie pierwszej cyfry(skrajna prawa)
;	ldr r5, =IO0SET
;	mov r4, r8
;	str r4, [r5]
;	
	;inkrementacja licznika, przeniesienie do rejestru zapalajacego
;	add CurrentDigit, CurrentDigit, #1
;	mov r8,r7, lsr CurrentDigit
	
	;mod4 licznika
;	cmp r8, #0x8000
;	eoreq r8, #0x88000
;	ldreq CurrentDigit, =0
;	
;	bl ms_delay
	
;	b main_loop
	
	
;ms_delay	
;	ldr r0, =0x200
;	ldr r1, =0x3a98
;	mul r1, r0, r1
;	
;ms_loop
;	subs r1,r1,#1
;	bne ms_loop
;	bx lr
	
; tablica kodów siedmiosegmentowych				
;Table DCB  0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f
;
;	end


;cw5i6
;
;CurrentDigit	rn	12
;	ldr CurrentDigit, =0x0
;	
;	ldr r5, =IO0DIR ;port0 - digits
;	ldr r4, =0xf0000
;	str r4, [r5]
;	
;	ldr r5, =IO1DIR ;port1 - segments
;	ldr r4, =0xff0000
;	str r4, [r5]
;	
;	ldr r5, =IO0SET
;	ldr r4, =0x80000
;	str r4, [r5]
;	
;	ldr r5, =IO1SET
;	ldr r4, =0x3f0000
;	str r4, [r5]
;	
;	ldr r6, =0x80000
;	ldr r7, =0x80000
;main_loop
;
;	
;	
;	;wygaszenie cyfr
;	ldr r5, =IO0CLR
;	ldr r4, =0xf0000
;	str r4, [r5]
;	
;	;zapalenie pierwszej cyfry(skrajna prawa)
;	ldr r5, =IO0SET
;	mov r4, r7
;	str r4, [r5]
;	
;	;inkrementacja licznika, przeniesienie do rejestru zapalajacego
;	add CurrentDigit, CurrentDigit, #1
;	mov r7,r6, lsr CurrentDigit
;	
;	;mod4 licznika
;	cmp r7, #0x8000
;	eoreq r7, #0x88000
;	ldreq CurrentDigit, =0
;	
;	bl ms_delay
;	b main_loop
;	
;	
;ms_delay	
;	ldr r0, =0x200
;	ldr r1, =0x3a98
;	mul r1, r0, r1
;	
;ms_loop
;	subs r1,r1,#1
;	bne ms_loop
;	bx lr
;	end



;cw4
;	ldr r1, =IO0DIR 
;	ldr r0, =0xf0
;	str r0, [r1] ;co ladujemy [gdzie-adres]
;	
;main_loop
;	bl ms_delay
;	ldr r1, =0x1
;	
;	b main_loop
;	
;	
;ms_delay	
;	ldr r0, =0x2
;	ldr r1, =0x3a98
;	mul r1, r0, r1
;	
;ms_loop
;	subs r1,r1,#1
;	bne ms_loop
;	bx lr
;	end


;cw3
;
;	
;main_loop
;	bl ms_delay
;	ldr r1, =0x1
;	
;	b main_loop
;	
;	
;ms_delay	
;	ldr r0, =0x2
;	ldr r1, =0x3a98
;	mul r1, r0, r1
;	
;ms_loop
;	subs r1,r1,#1
;	bne ms_loop
;	bx lr
;	end


;cw2
;
;	ldr r0, =0x2
;	ldr r1, =0x3a98
;	mul r1, r0, r1
;main_loop
;	subs r1,r1,#1
;	
;	bne main_loop
;	ldr r0,=0x1
;	END
		
		
;cw1 
;
;		ldr r0,=0x3e8
;main_loop
;		
;	subs r0,r0,#1	
;	
;	bne main_loop
;	ldr r0,=0x1
;	END

