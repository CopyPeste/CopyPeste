/*--------------------------------------------------------------------*/
/*		     Epitech EIP 2017 groupe Copypeste		      */
/*								      */
/*			    Tool Filter				      */
/*								      */
/* @by :	Guillaume Krier					      */
/* @created :	02/02/2015					      */
/* @update :	28/02/2015					      */
/*--------------------------------------------------------------------*/

/* INCLUDES */
#include "filter.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/*
** This function remove characters
** between Begin and End included
**
** @param: char *str - string
** @param: char *beg - first element
** @param: char *end - last element
** @return: Char* - return Char* param
*/
char	*filter_str(char *str, char *beg, char *end)
{
  int save = -1;
  char *tmp1 = str;
  char *tmp2 = str;

  while (*tmp2)
    {
      *tmp1 = *tmp2++;
      if (strncmp(tmp1, beg, strlen(beg)) == 0
	  && save == -1)
	save = 0;
      else if (strncmp(tmp1, end, strlen(end)) == 0
	       && save != -1)
	save = -1;
      else if (save == -1)
	  ++tmp1;
    }
  *tmp1 = 0;
  return str;
}

/*
** This function remove all spaces
** in the string
**
** @param: char *str - string
** @return: Char* - return Char* param
*/
char	*filter_space(char *str)
{
  char *tmp1 = str;
  char *tmp2 = str;

  while (*tmp2)
    {
      *tmp1 = *tmp2++;
      if (*tmp1 != ' ' && *tmp1 != '\t')
	++tmp1;
    }
  *tmp1 = 0;
  return str;
}

/*
** This function remove the multiple newlines
** in the string
**
** @param: char *str - string
** @return: Char* - return Char* param
*/
char	*filter_newline(char *str)
{
  char *tmp1 = str;
  char *tmp2 = str;

  while (*tmp2)
    {
      *tmp1 = *tmp2++;
      if (*tmp1 != '\n' || *(tmp1 + 1) != '\n')
	++tmp1;
    }
  *tmp1 = 0;
  return str;
}
