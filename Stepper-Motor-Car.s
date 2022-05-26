			area Project, code, readonly
			export __main
__main proc
			;sensor inputs
			ldr r0, =0x40004C00
			add r0, #0x40 ; Port5
			mov r1, #0x00 ; all pins are input/on
			strb r1, [r0, #0x04]

			mov r1, #0xFF
			strb r1, [r0, #0x06]
			mov r1, #0x00
			strb r1, [r0, #0x02] ;pull down resistor

			;stepper motors (output)
			ldr r2, =0x40004C00
			add r2, #0x21 ; port 4
			mov r3, #0xFF ;pins 0,1,2,3
			strb r3, [r2, #0x04]

			;mov r4, #0xF0 ; 4,5,6,7
			;strb r4, [r2, #0x06]

			ldr r4, =0x40004C00
			add r4, #0x20 ; port 3 output
			mov r5, #0xFF
			strb r5, [r4, #0x04]

			ldr r8, =toggleValue
			mov r5, #0x00 ; this stores toggle value
			strb r5, [r8]

			b check1
			endp 

check1 		function ; forward sensor
			ldrb r6, [r0, #0x00]
			and r7, r6, #0x04 ; P5.2
			cmp r7, #00
			bne check2
			b forward1
			endp

forward1 	function ; CCW
			mov r8, #0x0C
			strb r8, [r2, #0x02]
			bl delay

			mov r9, #0x06
			strb r9, [r2, #0x02] ;stores to output
			bl delay

			mov r10, #0x03
			strb r10, [r2, #0x02] ;stores to output
			bl delay

			mov r11, #0x09
			strb r11, [r2, #0x02] ;stores to output
			bl delay
			b check2
			endp


check2 		function ; backward sensor
			;ldrb r4, [r0, #0x00]
			and r7, r6, #0x01 ;P5.0
			cmp r7, #00
			bne check3
			b backward1
			endp

backward1 	function ;CW
			mov r8, #0x09
			strb r8, [r2, #0x02]
			bl delay

			mov r9, #0x03
			strb r9, [r2, #0x02] ;stores to output
			bl delay

			mov r10, #0x06
			strb r10, [r2, #0x02] ;stores to output
			bl delay

			mov r11, #0x0C
			strb r11, [r2, #0x02] ;stores to output
			bl delay

			b check3
			endp

;button1 function


check3 		function
			and r7, r6, #0x02 ; P5.1
			cbnz r7, buttonDown ; is button down?
			b check1

buttonDown 	ldr r8, =toggleValue
			ldrb r5, [r8]
			cbz r5, headliteOn
			b headliteOff
			endp

headliteOn   function
			mov r8, #0xC0 ; P3.6
			strb r8, [r4, #0x02]
			
			ldr r8, =toggleValue
			mov r5, #0x01
			strb r5, [r8]
			
			b check1
			endp

headliteOff 	function
			mov r8, #0x00 ; P3.7
			strb r8, [r4, #0x02]
			
			ldr r8, =toggleValue
			mov r5, #0x00
			strb r5, [r8]
			
			b check1
			endp

delay   	function
			mov r11, #50
outer   	mov r12, #255 
inner   	subs r12, #1
			bne inner
			subs r11, #1
			bne outer
			bx lr
			endp
	
			area Data, noinit, readwrite
toggleValue space 1

end