
CC	=	gcc
RM	=	rm -f
NAME	=	levenshtein
OBJS	=	$(SRCS:.c=.o)

SRCS	=	levenshtein.c \
		main.c

CFLAGS	+=	-std=c99

all:		$(NAME)

$(NAME):	$(OBJS)
		$(CC) $(CFLAGS) $(OBJS) -o $(NAME) 

clean:
		$(RM) $(OBJS)

fclean:		clean
		$(RM) $(NAME)

re:		fclean all
