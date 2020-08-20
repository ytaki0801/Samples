MOD=carr
SRC=${MOD}.c
DLL=${MOD}.so

${DLL}: ${SRC}
	cc -fPIC -Wall `python3-config --includes` -shared -o ${DLL} ${SRC} `python3-config --libs`

clean: ${DLL}
	rm -f ${DLL}

