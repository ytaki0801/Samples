#OBJ=guile-initfile
OBJ=guile-cfunc
SRC=${OBJ}.c

${OBJ}: ${SRC}
	cc `pkg-config guile-3.0 --cflags` -o ${OBJ} ${SRC} `pkg-config guile-3.0 --libs`

clean: ${OBJ}
	rm -f ${OBJ}
