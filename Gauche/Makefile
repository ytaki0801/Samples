#OBJ=gauche-fib
#OBJ=gauche-initfile
OBJ=gauche-call
SRC=${OBJ}.c

${OBJ}: ${SRC}
	cc -Wall `gauche-config -I` -o $@ ${SRC} `gauche-config --static-libs`

clean: ${OBJ}
	rm -f ${OBJ}
