#OBJS Specifies which files to compile
OBJS = rxvera.s

#OBJ_NAMe specifies the name of our executable
OBJ_NAME = rxvera.prg

#This is the target
all: $(OBJS)
	java -jar ../KickAss.jar -showmem -asminfo all -bytedump -libdir ./include/ $(OBJS) -o $(OBJ_NAME)

clean:
	rm -f *.prg *.sym *.txt
