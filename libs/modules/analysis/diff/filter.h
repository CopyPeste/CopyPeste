
#pragma once

/* PROTOTYPES */

/*
** Removes characters between Begin and End included
**
** @param: char *str - string
** @param: char *beg - first element
** @param: char *end - last element
** @return: Char* - return Char* param
*/
char	*filter_str(char *str, char *beg, char *end);

/*
** Removes all spaces in the string
**
** @param: char *str - string
** @return: Char* - return Char* param
*/
char	*filter_all_space(char *str);

/*
** Removes all spaces in the string
**
** @param: char *str - string
** @return: Char* - return Char* param
*/
char	*filter_space(char *str);

/*
** Removes all newlines in the string
**
** @param: char *str - string
** @return: Char* - return Char* param
*/
char	*filter_newline(char *str);
