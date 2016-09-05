CC =		gcc

RM =		rm -f

CFLAGS +=	-Wextra -Wall -Werror \
		-pedantic -std=gnu99 \
		-I../library/ \
		-I../levenshtein/ \

#optimisation flag
CFLAGS +=	-O2

LIB +=		../library/cp_library.so

NAME =		my_diff

SRCS =		test.c \
		diff.c \

OBJS =		$(SRCS:.c=.o)

all:		$(NAME)

$(NAME):	$(OBJS)
		$(CC) $(OBJS) $(LIB) -o $(NAME)

clean:
		$(RM) $(OBJS)

fclean:		clean
		$(RM) $(NAME)

re:		fclean all

.PHONY:		all clean fclean re
