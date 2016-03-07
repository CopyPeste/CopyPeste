
#pragma once

#include <stdlib.h>

/* DEFINES */
#define SIZE_RD_CHAR 512

/* PROTOTYPES */

/*
** Compares two files and finds
** if the sum of their characters are equal.
**
** @param: str_file1 - string representing the first file
** @param: str_file2 - string representing the second file
** @return: Integer - return the result of Diff compared
*/
int	rsync(char *str_file1, char *str_file2, size_t size_rd);

/*
** Compares two files and finds
** if the checksum of their characters are equal.
**
** @param: str_file1 - string representing the first file
** @param: str_file2 - string representing the second file
** @return: Integer - return the result of Diff compared
*/
int	rsync_checksum(char *str_file1, char *str_file2, size_t size_rd);
