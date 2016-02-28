/*--------------------------------------------------------------------*/
/*		     Epitech EIP 2017 groupe Copypeste		      */
/*								      */
/*			    Tool Filter				      */
/*								      */
/* @by :	Guillaume Krier					      */
/* @created :	02/02/2015					      */
/* @update :	28/02/2015					      */
/*--------------------------------------------------------------------*/
#pragma once

/* PROTOTYPES */

/*
** This function remove characters
** between Begin and End included
**
** @param: char *str - string
** @param: char *beg - first element
** @param: char *end - last element
** @return: Char* - return Char* param
*/
char	*filter_str(char *str, char *beg, char *end);

/*
** This function remove all spaces
** in the string
**
** @param: char *str - string
** @return: Char* - return Char* param
*/
char	*filter_space(char *str);

/*
** This function remove the multiple newlines
** in the string
**
** @param: char *str - string
** @return: Char* - return Char* param
*/
char	*filter_newline(char *str);
