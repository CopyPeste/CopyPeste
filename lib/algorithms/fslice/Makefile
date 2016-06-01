## Makefile
## Epitech EIP 2017 groupe Copypeste
## @by : Guillaume Krier

CC =		gcc

RM =		rm -f

CFLAGS +=	-Wextra -Wall -Werror
CFLAGS +=	-pedantic -std=gnu99
CFLAGS +=	-fmax-errors=2
CFLAGS +=	-I../levenshtein/

NAME =		my_fslice

SRCS =		main.c \
		fslice.c \
		file_handler.c \
		filter.c \
		compare.c \

OBJS =		$(SRCS:.c=.o)

all:		$(NAME)

$(NAME):	$(OBJS)
		$(CC) $(OBJS) -o $(NAME)

clean:
		$(RM) $(OBJS)

fclean:		clean
		$(RM) $(NAME)

re:		fclean all

.PHONY:		all clean fclean re
