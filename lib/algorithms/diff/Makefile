CC =		gcc

RM =		rm -f

CFLAGS +=	-Wextra -Wall -Werror
CFLAGS +=	-pedantic -std=gnu99
CFLAGS +=	-I../levenshtein/

#optimisation flag
CFLAGS +=	-O2

NAME =		my_diff

SRCS =		test.c \
		diff.c \
		filter.c \
		compare.c \
		file_handler.c \

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
