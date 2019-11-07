;
; AVR_Thread.asm
;
; Created: 2019-11-04 14:44:06
; Author : Moj
;

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
	
	ldi r16, 0b1010
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

	ldi r16, 10

	inc CtrA
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

	ldi r19, 5

    inc CtrB
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
