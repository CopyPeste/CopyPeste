## Makefile
## Epitech EIP 2017 groupe Copypeste
## @by : Guillaume Krier

CC =		gcc

RM =		rm -f

CFLAGS +=	-Wextra -Wall -Werror
CFLAGS +=	-pedantic -std=gnu99
CFLAGS +=	-fmax-errors=2

MY_FLAGS =	-lcrypto # MD5

NAME =		my_rsync

SRCS =		main.c \
		./rsync.c \

OBJS =		$(SRCS:.c=.o)

all:		$(NAME)

$(NAME):	$(OBJS)
		$(CC) $(OBJS) -o $(NAME) $(MY_FLAGS)

clean:
		$(RM) $(OBJS)

fclean:		clean
		$(RM) $(NAME)

re:		fclean all

.PHONY:		all clean fclean re
