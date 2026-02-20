.const CINV    			= $0314 // IRQ INTERRUPT ROUTINE

.const SCREEN_MODE		= $FF5F
.const SETNAM			= $FFBD
.const SETLFS			= $FFBA
.const LOAD				= $FFD5
.const IO_PAGE			= $9f
.const VERA_BASE		= $9F20
.const BSOUT			= $FFD2
.const BASIN			= $FFCF
.const GETIN			= $FFE4
.const MCIOUT			= $FEB1
.const MEMCOPY			= $FEE7
.const MACPTR			= $FF44
.const OPEN				= $FFC0
.const CLOSE			= $FFC3
.const CHKIN			= $FFC6
.const DEBUG			= $9FB9

.const R0				= $02
.const R0L				= $02
.const R0H				= $03
.const R1				= $04
.const R1L				= $04
.const R1H				= $05
.const R2				= $06
.const R2L				= $06
.const R2H				= $07
.const R3				= $08
.const R3L				= $08
.const R3H				= $09
.const R4				= $0A
.const R4L				= $0A
.const R4H				= $0B
.const R5				= $0C
.const R5L				= $0C
.const R5H				= $0D
.const R6				= $0E
.const R6L				= $0E
.const R6H				= $0F
.const R7				= $10
.const R7L				= $10
.const R7H				= $11
.const R8				= $12
.const R8L				= $12
.const R8H				= $13
.const R9				= $14
.const R9L				= $14
.const R9H				= $15
.const R10				= $16
.const R10L				= $16
.const R10H				= $17
.const R11				= $18
.const R11L				= $18
.const R11H				= $19
.const R12				= $1A
.const R12L				= $1A
.const R12H				= $1B
.const R13				= $1C
.const R13L				= $1C
.const R13H				= $1D
.const R14				= $1E
.const R14L				= $1E
.const R14H				= $1F
.const R15				= $20
.const R15L				= $20
.const R15H				= $21

.var VERA_ADDR_L		= VERA_BASE + $00
.var VERA_ADDR_M		= VERA_BASE + $01
.var VERA_ADDR_H		= VERA_BASE + $02
.var VERA_DATA0			= VERA_BASE + $03
.var VERA_DATA1			= VERA_BASE + $04
.var VERA_CTRL			= VERA_BASE + $05

.var VERA_IEN			= VERA_BASE + $06
.var VERA_ISR			= VERA_BASE + $07
.var VERA_IRQ_LINE_L	= VERA_BASE + $08

.var VERA_DC_VIDEO		= VERA_BASE + $09
.var VERA_DC_HSCALE		= VERA_BASE + $0A
.var VERA_DC_VSCALE		= VERA_BASE + $0B
.var VERA_DC_BORDER		= VERA_BASE + $0C

.var VERA_DC_HSTART		= VERA_BASE + $09
.var VERA_DC_HSTOP		= VERA_BASE + $0A
.var VERA_DC_VSTART		= VERA_BASE + $0B
.var VERA_DC_VSTOP		= VERA_BASE + $0C

.var VERA_L0_CONFIG		= VERA_BASE + $0D
.var VERA_L0_MAPBASE	= VERA_BASE + $0E
.var VERA_L0_TILEBASE	= VERA_BASE + $0F
.var VERA_L0_HSCROLL_L	= VERA_BASE + $10
.var VERA_L0_HSCROLL_H	= VERA_BASE + $11
.var VERA_L0_VSCROLL_L	= VERA_BASE + $12
.var VERA_L0_VSCROLL_H	= VERA_BASE + $13

.var VERA_L1_CONFIG		= VERA_BASE + $14
.var VERA_L1_MAPBASE	= VERA_BASE + $15
.var VERA_L1_TILEBASE	= VERA_BASE + $16
.var VERA_L1_HSCROLL_L	= VERA_BASE + $17
.var VERA_L1_HSCROLL_H	= VERA_BASE + $18
.var VERA_L1_VSCROLL_L	= VERA_BASE + $19
.var VERA_L1_VSCROLL_H	= VERA_BASE + $1A

.var VERA_AUDIO_CTRL	= VERA_BASE + $1B
.var VERA_AUDIO_RATE	= VERA_BASE + $1C
.var VERA_AUDIO_DATA	= VERA_BASE + $1D

.var VERA_SPI_DATA		= VERA_BASE + $1E
.var VERA_SPI_CTRL		= VERA_BASE + $1F

.const VERA_PSG_BASE     = $1F9C0
.const VERA_PALETTE_BASE = $1FA00
.const VERA_SPRITES_BASE = $1FC00

.const ram_bank = 0
.const rom_bank = 1

.const VIA1	=$9F00		//VIA 6522 #1
.var D1PRB	=VIA1+0
.var D1PRA	=VIA1+1
.var D1DDRB	=VIA1+2
.var D1DDRA	=VIA1+3
.var D1T1L	=VIA1+4
.var D1T1H	=VIA1+5
.var D1T1LL	=VIA1+6
.var D1T1LH	=VIA1+7
.var D1T2L	=VIA1+8
.var D1T2H	=VIA1+9
.var D1SR	=VIA1+10
.var D1ACR	=VIA1+11
.var D1PCR	=VIA1+12
.var D1IFR	=VIA1+13
.var D1IER	=VIA1+14
.var D1ORA	=VIA1+15

.const VIA2	=$9F10		//VIA 6522 #2
.var D2PRB	=VIA2+0
.var D2PRA	=VIA2+1
.var D2DDRB	=VIA2+2
.var D2DDRA	=VIA2+3
.var D2T1L	=VIA2+4
.var D2T1H	=VIA2+5
.var D2T1LL	=VIA2+6
.var D2T1LH	=VIA2+7
.var D2T2L	=VIA2+8
.var D2T2H	=VIA2+9
.var D2SR	=VIA2+10
.var D2ACR	=VIA2+11
.var D2PCR	=VIA2+12
.var D2IFR	=VIA2+13
.var D2IER	=VIA2+14
.var D2ORA	=VIA2+15

//
// VERA Video RAM Layout
//
// $0:0000 - $1:2BFF  320x240@256c Bitmap 
// $1:2C00 - $1:2FFF  -- unused --
// $1:3000 - $1:AFFF  Sprites $1000 per sprite
// $1:B000 - $1:EBFF  Text Mode
// $1:EC00 - $1:EFFF  -- unused --
// $1:F000 - $1:F7FF  Charset
// $1:F800 - $1:F9BF  -- unused --
// $1:F9C0 - $1:FFFF  Vera internal PSG, pal, spr

.const FB_ADDR      = $00000	//; CODE ASSUMES 64K ALIGNED
.const SPRITE_ADDR  = $13000
.const SCREEN_ADDR  = $1B000
.const CHARSET_ADDR = $1F000

//
// YM2151 IO registers
//
.const YM_REG  = $9F40
.const YM_DATA = $9F41
