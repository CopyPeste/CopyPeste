##
## Unix commands
##
CC	=	gcc
RM	=	rm -rf
MKDIR	=	mkdir -p

##
## compilation paths
##
LIB_NAME =	algorithms.so

SRCS	 =	\
		./library/sources/file/filter.c \
		./library/sources/file/file_handler.c \
		./library/sources/tools/compare.c \
\
		./levenshtein/levenshtein.c \
		./rsync/rsync.c \
		./fdupes/fdupes_algo.c \
		./fdupes/md5/md5.c \
		./hamming_distance/hamming_distance.c \
		./diff/diff.c \


##
## compilation flags
##
CFLAGS +=	-Wextra -Wall -Werror
CFLAGS +=	-pedantic -std=gnu99

CFLAGS +=	-I./rsync/includes \
		-I./rsync/message_digest \
		-I./rsync/compare \
		-I./rsync/errno_copypeste \
		-I./library/includes/tools \
		-I./library/includes/file \
		-I./diff \

CFLAGS +=	-lcrypto # MD5

##
## Optimisation flag
##
CFLAGS	+=	-O2

all:		$(LIB_NAME)

$(LIB_NAME):	$(OBJS)
		$(CC) -o $(LIB_NAME) $(LIB) -shared -fPIC $(SRCS) $(CFLAGS)

clean:
		$(RM) $(LIB_NAME)

re:		clean all

.PHONY:		all clean re
