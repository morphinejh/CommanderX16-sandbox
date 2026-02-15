/*
 *MIT License
 *Copyright (c) 2026 morphinejh
 *
 * Example to receive data form serial port and
 * write to VERA memory to fill screen background
 * in screen mode $80/128
 *
 * Load with: %RXVERA.PRG or LOAD"RXVERA.PRG",8,1"
 * Call with: SYS $400
 *
 * Sets screen mode $80 and waits for data to be received.
 * Checks for screen mode $80 so as not to clear screen if
 * active.
 *
 * Send raw serial data to COM port, press any key to
 * stop listening.
 *
 * see 'include/serial.inc'
 * for base addresses and baud rate settings
 *
 */
 
#import "x16.inc"
#import "serial.inc"

.cpu _65c02

*=$0400	"rxvera"						//CHANGE AS NEEDED

MAIN:
		jsr UART_SETUP
		jsr VERA_SETUP
		jsr SERIAL_LISTEN
		rts								//EXITS TO PROMPT
	
VERA_SETUP:
		sec
		jsr SCREEN_MODE
		cmp #$80
		beq VERA_CONT1					//CHECK FOR 'SCREEN $80' ALREADY
		lda #$80
		clc
		jsr SCREEN_MODE
	VERA_CONT1:	
		lda #0
		sta VERA_ADDR_L
		sta VERA_ADDR_M
		lda #$10						//INCREMENT BY 1
		sta VERA_ADDR_H


UART_SETUP:
		lda #INTR_SETUP					//ENABLE THE DATA READY INTERRUPT ON THE UART
		sta INTERRUPT_ENABLE
		lda #FIFO_SETUP					//ENABLE FIFO BUFFER
		sta FIFO_CONTROL
		lda #%10000000					//SETS BAUD RATE DIVISOR
		sta LINE_CONTROL
		lda #<BAUD_RATE_DIVISOR
		sta DIVISOR_LATCH_LOW
		lda #>BAUD_RATE_DIVISOR
		sta DIVISOR_LATCH_HI
		lda #LCR_SETUP					//SETS WORD LENGTH TO 8 BITS
		sta LINE_CONTROL
		lda #%00100011					//MAKES UART READY TO SEND and RECIEVE DATA
		sta MODEM_CONTROL				//ALSO ENABLE AUTOFLOW CONTROL
		rts

TRANSFER_DATA:
		lda RX_BUFFER
		sta VERA_DATA0

SERIAL_LISTEN:
		lda LINE_STATUS
		and #%00000001					//CHECK FOR FIFO DATA
		bne TRANSFER_DATA				//HANDLE IF DATA EXISTS
		jsr GETIN						//EXIT ON KEY STROKE
		beq SERIAL_LISTEN
		rts								//EXITS TO MAIN
