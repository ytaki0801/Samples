#OBJ=python3-cfunc0
OBJ=python3-cfunc
#OBJ=python3-cfunc-listargs
SRC=${OBJ}.c

${OBJ}: ${SRC}
	cc `python3-config --includes` -o ${OBJ} ${SRC} `python3-config --libs`

clean: ${OBJ}
	rm -f ${OBJ}
