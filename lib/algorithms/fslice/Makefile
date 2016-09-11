CC =		gcc

RM =		rm -f

CFLAGS +=	-Wextra -Wall -Werror \
		-pedantic -std=gnu99 \
		-I../levenshtein/ \
		-I../library/includes/tools \
		-I../library/includes/file \

# Optimisation flag
CFLAGS +=	-O2

LIB +=		../library/cp_library.so

NAME =		my_fslice

SRCS =		main.c \
		fslice.c \

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
