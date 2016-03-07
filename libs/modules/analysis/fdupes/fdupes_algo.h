

#ifndef	FDUPES_ALGO_H_
# define FDUPES_ALGO_H_

#include <sys/stat.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "md5/md5.h"

#define CHUNK_SIZE 8192
#define INPUT_SIZE 256
#define PARTIAL_MD5_SIZE 4096
#define MD5_DIGEST_LENGTH 16

int		fdupes_match(char *, int, char *, int);

#endif /* FDUPES_ALGO_H_ */
