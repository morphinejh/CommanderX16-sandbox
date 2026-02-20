#OBJS Specifies which files to compile
OBJS = rxirqvera.s

#OBJ_NAMe specifies the name of our executable
OBJ_NAME = rxirqvera.prg

#This is the target
all: $(OBJS)
	java -jar ../KickAss.jar -showmem -asminfo all -bytedump -libdir ./include/ $(OBJS) -o $(OBJ_NAME)

clean:
	rm -f *.prg *.sym *.txt
