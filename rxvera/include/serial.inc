//The SERIAL RS232 IO base, check IO - Hi/Lo jumper on the card.

//.const IO_BASE = $9F68 //IO3 Low - 8MHz
.const IO_BASE = $9FE8 //IO7 Low - 2MHz

.var RX_BUFFER           = IO_BASE               //READ ONLY
.var TX_HOLDING          = IO_BASE               //WRITE ONLY
.var INTERRUPT_ENABLE    = IO_BASE + 1
.var INTERRUPT_IDENT     = IO_BASE + 2           //READ ONLY
.var FIFO_CONTROL        = IO_BASE + 2           //WRITE ONLY
.var LINE_CONTROL        = IO_BASE + 3
.var MODEM_CONTROL       = IO_BASE + 4
.var LINE_STATUS         = IO_BASE + 5
.var MODEM_STATUS        = IO_BASE + 6
.var SCRATCH             = IO_BASE + 7

// When Divsor Latch = 1 (LINE_STATUS)
.var DIVISOR_LATCH_LOW   = IO_BASE
.var DIVISOR_LATCH_HI    = IO_BASE + 1

/* Line Control Register Flags
 Bit 7				: Divisor Latch
 Bit 6				: Break Control
 Bit 5				: Sticky Parity
 Bit 4				: Parity Select
 Bit 3				: Parity Enable (0 for none)
 Bit 2				: Stop Bits (0 to 1 stop bit)
 Bits 0 & 1	: Word Length (both to 1 = 8-bits)
 No Partity, 1 Stop, 8-Bits
*/
.const LCR_SETUP  = %00000011

/* Interrupt Enable Flags
 Bits 7-4		: Unused (always cleared)
 Bit 3				: 1 = Enable Modem Status Interrupt
 Bit 2				: 1 = Enable Receiver Line Status Intterupt
 Bit 1				: 1 = Enable THRE (Transmission Holding Register) Interrupt
 Bit 0				: 1 = Enable Received Data Available Interrupt
*/
.const INTR_SETUP = %00000000

/* FIFO Control Register Flags
 Bits 7-6		: Buffer trigger level (00 = $01, 01 = $04, 10 = $08, 11 = $0E)
 Bits 5-4		: Reserved
 Bit 3				: When FCR0 set, assert !RXRDY and !TXRDY pins
 Bit 2				: Clears TX FIFO and counter
 Bit 1				: Clears RX FIFO and counter
 Bit 0				: Enable FIFO Buffers
*/
//.const FIFO_SETUP = %11000111
//only 8 byte trigger (14 byte doesn't give enough reaction time with interrupts at 921600)
.const FIFO_SETUP = %10000111

//9600
//.const BAUD_RATE_DIVISOR = $0060

//115200
//.const BAUD_RATE_DIVISOR = $0008

//921600
.const BAUD_RATE_DIVISOR = $0001
