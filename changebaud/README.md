# changebaud
Demonstration of programmatically changinge the baud rate with Zimodem.

## Usage
- Load with:
   - Using flow control
      - `BASLOAD"CBFLOW.BAS"`
   - Not using flow control
      - `BASLOAD"CBNOFLOW.BAS"`
- Call with:
   - `RUN`

This program expects the Zimodem firmware to be at 115200 baud when started. It will then test at that baud rate, switch to 9600 and test, then switch back to 115200 and test once more.

Hardware flow control is used and the FIFO is enabled.

### Make sure your Zimodem firmware has flow control enabled before starting.
