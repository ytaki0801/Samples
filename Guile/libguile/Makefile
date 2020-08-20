#OBJ=guile-cfunc0
#OBJ=guile-cfunc
OBJ=guile-cfunc-listargs
SRC=${OBJ}.c

${OBJ}: ${SRC}
	cc `pkg-config guile-3.0 --cflags` -o ${OBJ} ${SRC} `pkg-config guile-3.0 --libs`

clean: ${OBJ}
	rm -f ${OBJ}
