##
## Unix commands
##
CC	=	gcc
RM	=	rm -rf

##
## compilation paths
##
LIB_NAME =	cp_library.so

SRCS	 =	./sources/file/filter.c \
		./sources/file/file_handler.c \
		./sources/tools/compare.c \

##
## compilation flags
##
CFLAGS +=	-Wextra -Wall -Werror
CFLAGS +=	-pedantic -std=gnu99

CFLAGS +=	-I./includes/file/ \
		-I./includes/tools/ \

##
## Optimisation flag
##
all:		$(LIB_NAME)

$(LIB_NAME):	$(OBJS)
		$(CC) -o $(LIB_NAME) -shared -fPIC $(SRCS) $(CFLAGS)

clean:
		$(RM) $(LIB_NAME)

re:		clean all

.PHONY:		all clean re
