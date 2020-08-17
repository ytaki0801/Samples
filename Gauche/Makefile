#OBJ=gauche-fib
OBJ=gauche-initfile
SRC=${OBJ}.c

${OBJ}: ${SRC}
	cc -Wall `gauche-config -I` -o $@ ${SRC} `gauche-config --static-libs`

clean: ${OBJ}
	rm -f ${OBJ}
