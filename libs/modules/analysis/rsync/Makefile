## Makefile
## Epitech EIP 2017 groupe Copypeste
## @by : Guillaume Krier

CC =		gcc

RM =		rm -f

CFLAGS +=	-Wextra -Wall -Werror
CFLAGS +=	-pedantic -std=gnu99
CFLAGS +=	-fmax-errors=2
CFLAGS +=	-I./includes \
		-I./message_digest \
		-I./compare \
		-I./errno_copypeste \

CFLAGS +=	-DEN_MSG_ERROR # ENABLE MESSAGE ERROR

MY_FLAGS =	-lcrypto # MD5

NAME =		my_rsync

SRCS =		main.c \
\
		./compare/compare_files_match.c \
\
		./message_digest/cp_md5.c \

OBJS =		$(SRCS:.c=.o)

all:		$(NAME)

opo:		CFLAGS += -DONE_PER_ONE 
opo:		$(NAME)

$(NAME):	$(OBJS)
		$(CC) $(OBJS) -o $(NAME) $(MY_FLAGS)

clean:
		$(RM) $(OBJS)

fclean:		clean
		$(RM) $(NAME)

re:		fclean all

reopo:		fclean opo

.PHONY:		all clean fclean re
