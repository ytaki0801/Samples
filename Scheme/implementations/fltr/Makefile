# [Example]
# make
# mkdir ~/fltr
# cp -p ./fltr ./init.lsp ~/fltr/
# alias fltr='rlwrap ~/fltr/fltr ~/fltr/init.lsp'
# make clean

OBJ=fltr
INI=init.lsp
SRC=$(OBJ).c

$(OBJ): $(SRC) $(INI)
	cc -Wall -o $@ $(SRC)

clean:
	rm -f $(OBJ)
