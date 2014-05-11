all: url_lexer

url_lexer: url_lexer.c
	gcc -Wall -o url_lexer url_lexer.c

url_lexer.c: url_lexer.l
	flex -o url_lexer.c url_lexer.l
