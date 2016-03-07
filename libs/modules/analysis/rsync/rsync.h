
#pragma once

#include <stdlib.h>

/* DEFINES */
#define SIZE_RD_CHAR 512

/* PROTOTYPES */

/*
** This function compares two files and finds
** if the sum of their characters are equal.
**
** @param: path1 - the string of the first file
** @param: path2 - the string of the second file
** @return: Integer - return the result of Diff compared
*/
int	rsync(char *str_file1, char *str_file2, size_t size_rd);

/*
** This function compares two files and finds
** if the checksum of their characters are equal.
**
** @param: path1 - the string of the first file
** @param: path2 - the string of the second file
** @return: Integer - return the result of Diff compared
*/
int	rsync_checksum(char *str_file1, char *str_file2, size_t size_rd);
