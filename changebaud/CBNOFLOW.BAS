base_addr = $9FE0

baudSlow_divisor	=96:REM 9600 BAUD
baudFast_divisor	=8 :REM 115200 BAUD
working_divisor	=0
status = 1
command$		=""

## Need ANSI letters
print chr$(15)
print"---------------------------------"
print "starting baud 115200"
print"---------------------------------"
working_divisor=baudFast_divisor
gosub uart_setup
command$="ATI"
gosub send_command
gosub get_response

print"---------------------------------"
print "changing baud 9600"
print"---------------------------------"
command$="ATB9600"
gosub send_command
gosub get_response

gosub delayloop
working_divisor=baudSlow_divisor
gosub uart_setup
command$="ATI"
gosub send_command
gosub get_response

print"---------------------------------"
print "changing baud back to 115200"
print"---------------------------------"
command$="ATB115200"
gosub send_command
gosub get_response

gosub delayloop
working_divisor=baudFast_divisor
gosub uart_setup
command$="ATI"
gosub send_command
gosub get_response


end

get_response:
	loopgr1:status = peek(base_addr+5) AND $01
			if status=0 then loopgr1

	loopgr2:recv = (peek(base_addr))
			print chr$(recv);
			status = peek(base_addr+5) AND $01
			if status=1 then loopgr2
return

send_command:

	for x=1 to len(command$)
			byte=asc(mid$(command$,x,1))
			poke base_addr,byte
	loopss1:status = peek(base_addr+5) AND $01
			if status=0 then loopss1
			
	loopss2:print chr$(peek(base_addr));
			status = peek(base_addr+5) AND $01
			if status=1 then loopss2
	next x

	REM Carriage Return
	poke base_addr,13
return

flush_uart:
			status = peek(base_addr+5) AND $01
			if status=0 then exitfa
	loopfa1:recv = (peek(base_addr))
			REM NO NEED TO CARE ABOUT VALUE
			status = peek(base_addr+5) AND $01
			if status=1 then loopfa1
	exitfa:
return

delayloop:
	for x=1 to 5000
	next x
	
	gosub flush_uart
return

uart_setup:
	
	## Prepare write to Divisor Latch
	poke base_addr+3, $80
	poke base_addr, working_divisor
	poke base_addr+1, 0
	
	## Prepare disable divisor latch and set start/stop bits
	poke base_addr+3, $03
	
	## Enable FIFOs, don't worry about trigger in BASIC
	## No flow control on this test, make sure Zimodem is disabled as well
	poke base_addr+2, $01

return