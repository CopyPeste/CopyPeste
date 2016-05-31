##
## Unix commands
##
CC	=	gcc
RM	=	rm -rf
MKDIR	=	mkdir -p

##
## compilation paths
##
LIB_NAME =	./libs/algorithms.so

SRCS	 =	./levenshtein/levenshtein.c \
		./rsync/rsync.c \
		./fdupes/fdupes_algo.c \
		./fdupes/md5/md5.c \
		./hamming_distance/hamming_distance.c \
		./fslice/fslice.c \
		./fslice/file_handler.c \
		./fslice/filter.c \
		./fslice/compare.c \

LIB_DIRECTORY =	./libs

##
## complation flags
##
CFLAGS +=	-Wextra -Wall -Werror
CFLAGS +=	-pedantic -std=gnu99
CFLAGS +=	-fmax-errors=2

CFLAGS +=	-I./rsync/includes \
		-I./rsync/message_digest \
		-I./rsync/compare \
		-I./rsync/errno_copypeste \

CFLAGS +=	-lcrypto # MD5

all:		$(LIB_NAME)

$(LIB_NAME):	$(OBJS)
		$(MKDIR) $(LIB_DIRECTORY)
		$(CC) -o $(LIB_NAME) -shared -fPIC $(SRCS) $(CFLAGS)

clean:
		$(RM) $(LIB_DIRECTORY)

re:		clean all

.PHONY:		all clean re
