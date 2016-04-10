
#pragma once

#define MAX_GAP 10

/* PROTOTYPES */

/*
** Gets the difference between two files,
** line by line.
** Remove useless characters in files.
** Return the percentage of difference to obtain the same file.
**
** @param: str_file1 - string containing the first file
** @param: str_file2 - string containing the second file
** @return: Integer - returns the comparison result in percentage
** or -1 in case of error
*/
double diff(char *str_file1, char *str_file2);
