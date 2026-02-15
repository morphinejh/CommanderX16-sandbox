@ECHO off    
if /i [%1] == [] goto :default
if /i %1 == clean goto :clean

	
:default
echo Making
	CALL :makeme
goto :end

:clean
echo Cleaning
del *.prg
del *.sym
del *.txt
goto :end

:makeme
	echo on
	java -jar ..\KickAss.jar -showmem -asminfo all -bytedump -libdir .\include\ rxvera.s -o rxvera.prg
	echo off
	EXIT /b

:end
