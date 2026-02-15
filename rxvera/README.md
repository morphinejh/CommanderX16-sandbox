# rxvera
Demonstration of using serial data to draw an image on the screen

## Assembling
A `make.bat` and `Makefile` are included for reference. The assembler, [KickAssembler.jar](https://theweb.dk/KickAssembler/Main.html#frontpage), is expected to be in the parent directory.

## Usage
- Load with:
   - `%RXVERA.PRG` or `LOAD"RXVERA.PRG",8,1"`
- Call with:
   - `SYS $400`

Sets screen mode $80 and waits/blocks for data to be received and placed in VERA memory starting at address $0-0000.

When ran, it also checks for screen mode $80 so as not to clear screen if active. This allows running multiple times without wiping out the current back ground image.

Send raw serial data to the COM port, press any key on the X16 to stop listening (or when complete).

see `include/serial.inc` for base addresses and baud rate settings

#### There are no bounds checks - don't send more data than avaible VRAM available to use.
