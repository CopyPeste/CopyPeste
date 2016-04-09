
#pragma once

#define MAX_GAP 10

/* PROTOTYPES */

/*
** Gets the percentage diference between two files,
** word by word.
** Return the percentage difference between two strings,
** word by word algorithm.
**
** @param: str_file1 - struct line containing the first line
** @param: str_file2 - struct line containing the second line
** @return: Integer - return comparison value in percentage
*/
double diff(char *str_file1, char *str_file2);
