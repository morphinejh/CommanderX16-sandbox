# rxirqvera
Demonstration of using serial data to draw an image on the screen using interrupts.

## Assembling
A `make.bat` and `Makefile` are included for reference. The assembler, [KickAssembler.jar](https://theweb.dk/KickAssembler/Main.html#frontpage), is expected to be in the parent directory.

## Usage
- Load with:
   - `%RXIRQVERA.PRG` or `LOAD"RXIRQVERA.PRG",8,1"`
- Call with:
   - `SYS $400`

Sets screen mode $80 and loads an Interrupt routine for data to be received and placed in VERA memory starting at address $0-0000.

It does not need to be called multiple times. It will always be listening and will redraw an image back at the top of memory if the VRAM location exceeds 72,600 bytes [$1-2C00] (320x245 256 color image).

Send raw serial data to the COM port. If a partial image is sent, the next stream of data will begin at the address where the other left off.

see `include/serial.inc` for base addresses and baud rate settings.

### The interrupt does not check if it is currently loaded. Loading it twice may crash your system.

#### Important Memory Locations 
- These are incremented on receive, but can be set when not receiving data.
    - $22 - Vera ADDR_L memory address to send data
    - $23 - Vera ADDR_M memory address to send datat
    - $24 - Vera ADDR_H memory address to send datat
    - $25-$26 - DEFAULT IRQ to jump to after serial IRQ processed

#### Possible Speed Improvements
- Use VERA DATA1 rather than DATA0 to avoid saving, reloading, and manually incrementing values.
