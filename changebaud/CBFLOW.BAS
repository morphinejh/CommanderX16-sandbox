base_addr = $9FE0
baudSlow_divisor	=96:REM 9600 BAUD
baudFast_divisor	=8 :REM 115200 BAUD
working_divisor		=0
delayjiffies 		=60
status 				=1
command$			=""

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
gosub send_command: print" "
working_divisor=baudSlow_divisor
gosub uart_setup
gosub get_response
command$="ATI"
gosub send_command
gosub get_response

print"---------------------------------"
print "changing baud back to 115200"
print"---------------------------------"
command$="ATB115200"
gosub send_command: print" "
working_divisor=baudFast_divisor
gosub uart_setup
delayjiffies=60:gosub delayloop
command$="ATI"
gosub send_command
gosub get_response

end

## #################################################
## -------------Subroutines below this line------ ##
## #################################################

get_response:

	loopgr1:status = peek(base_addr+5) AND $80
			if status<>0 then loopgr1
			status = peek(base_addr+5) AND $01
			if status=0 then loopgr1

	loopgr2:recv = (peek(base_addr))
			print chr$(recv);
			status = peek(base_addr+5) AND $80
			if status<>0 then loopgr1
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

## flushes uart without printing any characters
flush_uart:
			print:print "FLUSH UART"
			status = peek(base_addr+5) AND $01
			if status=0 then exitfa
			## Halt RTS/CTS
			poke base_addr+4, $01
			## Clear FIFOs
			poke base_addr+2, $07
			## Renable flow control
			poke base_addr+4, $27
			delayjiffies=10:gosub delayloop
	loopfa1:recv = (peek(base_addr))
			REM NO NEED TO CARE ABOUT VALUE
			status = peek(base_addr+5) AND $01
			if status=1 then loopfa1
	exitfa:
return

## flushes uart and prints any characters
read_flush:
		print:print "READ FLUSH"
	rf1:
		status = peek(base_addr+5) AND $80
		if status<>0 then read_flush
		status = peek(base_addr+5) AND $01
		if status=0 then exitrf
	looprf1:recv = (peek(base_addr))
		print chr$(recv);
		goto rf1
	exitrf:
return

## Delay loop isn jiffies, just set 'delayjiffies' variable
delayloop:
	starti = ti
	tiloop:
		if (ti-starti)<delayjiffies goto tiloop
return

uart_setup:
	
	## Turn off RTS/AFE while adjusting baud
	poke base_addr+4, $0
	
	## Prepare write to Divisor Latch
	poke base_addr+3, $80
	poke base_addr, working_divisor
	poke base_addr+1, 0
	
	## Prepare disable divisor latch and set start/stop bits
	poke base_addr+3, $03
	
	## Enable FIFOs, erase them, but don't worry about trigger in BASIC
	poke base_addr+2, $01
	poke base_addr+2, $07

	## clear interrupt delta flags by reading
	status = peek(base_addr+6)
	status = peek(base_addr+6)
	
	## Enale flow control and AFE, make sure Zimodem is disabled as well
	poke base_addr+4, $27

return
