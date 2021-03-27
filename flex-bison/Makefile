# 2021/03/27: bison (GNU Bison) 3.5.1 and flex 2.6.4

NAME = sample

all: $(NAME).tab.c lex.yy.c
	cc $(NAME).tab.c -lfl

$(NAME).tab.c: $(NAME).y
	bison $(NAME).y

lex.yy.c: $(NAME).l
	flex $(NAME).l

clean:
	rm -f $(NAME).tab.c lex.yy.c a.out

