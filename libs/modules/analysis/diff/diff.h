
#pragma once

/* PROTOTYPES */

/*
** This function gets the difference between two files,
** line by line.
** Remove useless characters.
** Return the percentage of difference to obtain the same file.
**
** @param: str_file1 - the string of the first file
** @param: str_file2 - the string of the second file
** @return: Integer - return the result of compare in percentage
*/
double diff(char *str_file1, char *str_file2);
