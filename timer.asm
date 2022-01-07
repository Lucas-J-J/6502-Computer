;	Blinks an LED at a set interval of every 10000 clock pulses.
;	Used to understand how a computer handles delay commands and
;	interrupts.

PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003
T1CL = $6004
T1CH = $6005
ACR = $600b
IFR = $600d
IER = $600e

ticks = $00			; 4 bytes
toggle_time = $04	; 2 bytes
message = $06		; 2 bytes

E = %10000000
RW = %01000000
RS = %00100000

	.org $8000
	
reset:
	; LDE Setup
	lda #%10000111	; Set pins 0, 5, 6, 7 on A to output
	sta DDRA
	lda #0
	sta PORTA
	sta toggle_time
	jsr init_timer
	
loop:
	jsr update_led
	jmp loop
	

update_led:
	sec
	lda ticks
	sbc toggle_time
;	cmp #25		; Have 250ms elapsed?
	cmp #1
	bcc exit_update_led
	lda #$01
	eor PORTA
	sta PORTA	; Toggle LED
	lda ticks
	sta toggle_time
exit_update_led:
	rts

init_timer:
	lda #0  
	sta ticks		; 0000
	sta ticks + 1	; 0001
	sta ticks + 2	; 0002
	sta ticks + 3	; 0003
	lda #%01000000
	sta ACR			; 600b
	lda #$0e
	sta T1CL		; 6004
	lda #$27
	sta T1CH		; 6005
	lda #%11000000
	sta IER			; 600e
	cli
	rts

	
irq:
	bit T1CL
	inc ticks
	bne end_irq
	inc ticks + 1
	bne end_irq
	inc ticks + 2
	bne end_irq
	inc ticks + 3
end_irq:
	rti
	
	.org $fffc
	.word reset
	.word irq