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
LIB =		./library/cp_library.so

SRCS	 =	./levenshtein/levenshtein.c \
		./rsync/rsync.c \
		./fdupes/fdupes_algo.c \
		./fdupes/md5/md5.c \
		./hamming_distance/hamming_distance.c \
		./diff/file_handler.c \
		./diff/filter.c \
		./diff/diff.c \
		./diff/compare.c \

##
## compilation flags
##
CFLAGS +=	-Wextra -Wall -Werror
CFLAGS +=	-pedantic -std=gnu99

CFLAGS +=	-I./rsync/includes \
		-I./rsync/message_digest \
		-I./rsync/compare \
		-I./rsync/errno_copypeste \

CFLAGS +=	-lcrypto # MD5

##
## Optimisation flag
##
CFLAGS	+=	-O2

all:		$(LIB_NAME)

$(LIB_NAME):	$(OBJS)
ifneq ("$(wildcard $(LIB))","")
		echo "Library Done"
else
		make -C ./library
endif
		$(CC) -o $(LIB_NAME) $(LIB) -shared -fPIC $(SRCS) $(CFLAGS)

clean:
ifneq ("$(wildcard $(LIB))","")
		rm $(LIB)
endif
		$(RM) $(LIB_NAME)

re:		clean all

.PHONY:		all clean re
