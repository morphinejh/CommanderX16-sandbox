/*
 *MIT License
 *Copyright (c) 2026 morphinejh
 *
 * Example to receive data form serial port and
 * write to VERA memory to fill screen background
 * in screen mode $80/128 - using interrupts
 *
 * Load with: %RXIRQVERA.PRG or LOAD"RXIRQVERA.PRG",8,1"
 * Call with: SYS $400
 *
 * Sets screen mode $80 and monitors for data to be received.
 *
 * Send raw serial data to COM port. Only needs to be loaded
 * once, fills creen then resets to address $0-0000. 
 *
 * See VERA addresses below to reset screen location manual.
 *
 * see 'include/serial.inc'
 * for base addresses and baud rate settings
 *
 */
 
#import "x16.inc"
#import "serial.inc"

.cpu _65c02

.const VERA_L		=$22
.const VERA_M		=$23
.const VERA_H		=$24
.const DEFAULT_IRQ	=$25 //and $26

*=$0400	"rxirqvera"

MAIN:
	jsr INIT_IRQ
	jsr UART_SETUP
	jsr SETUP
	
	//Done, back to basic.
	rts
	
SETUP:
	sec
	jsr SCREEN_MODE
	cmp #$80
	beq VERA_CONT1				//CHECK FOR 'SCREEN $80' ALREADY
	lda #$80
	clc
	jsr SCREEN_MODE
	
VERA_CONT1:	
	lda #0
	sta VERA_ADDR_L
	sta VERA_ADDR_M
	lda #$10					//INCREMENT BY 1
	sta VERA_ADDR_H
	rts

UART_SETUP:
	lda #INTR_SETUP				//ENABLE THE DATA READY INTERRUPT ON THE UART
	sta INTERRUPT_ENABLE
	lda #FIFO_SETUP				//ENABLE FIFO BUFFER
	sta FIFO_CONTROL
	lda #%10000000				//SETS BAUD RATE DIVISOR
	sta LINE_CONTROL
	lda #<BAUD_RATE_DIVISOR
	sta DIVISOR_LATCH_LOW
	lda #>BAUD_RATE_DIVISOR
	sta DIVISOR_LATCH_HI
	lda #LCR_SETUP				//SETS WORD LENGTH TO 8 BITS
	sta LINE_CONTROL
	lda #%00101011				//MAKES UART READY TO SEND and RECIEVE DATA
	sta MODEM_CONTROL			//ALSO ENABLE AUTOFLOW CONTROL and INTERRUPTS
	rts

INIT_IRQ:

	lda CINV					//SAVE THE DEFAULT IRQ POINTER
	sta DEFAULT_IRQ
	lda CINV+1
	sta DEFAULT_IRQ+1

	sei							//DISABLE INTERRUPTS
	lda #<CUSTOM_IRQ			//REPLACE IRQ POINTER WITH CUSTOM POINTER
	sta CINV
	lda #>CUSTOM_IRQ
	sta CINV+1
	cli							//RE-ENABLE INTERRUPTS
INIT_IRQ_DONE:
	rts

CUSTOM_IRQ:
	jsr SERIAL_IRQ
	jmp (DEFAULT_IRQ)

//--------------------------------------------------------

SERIAL_IRQ:
	lda INTERRUPT_IDENT			//DETERMINE IF INTERRUPT IS CAUSED BY UART
	and #%00000100
	beq SERIAL_IRQ_HANDLED

TRANSFER_DATA:
	lda RX_BUFFER				//READ DATA FROM THE UART and STORE IT TO BANKED RAM

	ldx VERA_L
	ldy VERA_M
	stx VERA_ADDR_L
	sty VERA_ADDR_M
	ldy VERA_H
	sty VERA_ADDR_H
	
	ldy #0
	sty VERA_CTRL

	sta VERA_DATA0
	
	inx
	stx VERA_L
	txa
	bne DETECT_DATA				//Check if X rolled-over (i.e. is zero)
	ldy VERA_M
	
VERAFULL:						//Check if VERA is at buffer limit
	cpy #$2C					//$X-1FFF about to roll over to $X-2C00
	bcc VERANORMAL
	lda VERA_H
	cmp $01
	beq VERANORMAL				//Not zero set if equal
	ldx #0
	stx VERA_L
	stx VERA_M

	and #$FE					//VERA_H is in Accumulator
	sta VERA_H
	bra SERIAL_IRQ_HANDLED
	
VERANORMAL:	
	iny
	sty VERA_M
	bne DETECT_DATA
	ldx VERA_H
	inx
	stx VERA_H	
	
DETECT_DATA:
	lda LINE_STATUS
	and #%00000001				//CHECK FOR FIFO DATA
	bne TRANSFER_DATA			//HANDLE IF DATA EXISTS
	
SERIAL_IRQ_HANDLED:
	rts
