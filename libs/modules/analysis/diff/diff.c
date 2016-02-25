/*--------------------------------------------------------------------*/
/*		     Epitech EIP 2017 groupe Copypeste		      */
/*								      */
/*			    Algo diff				      */
/*								      */
/* @by :	Guillaume Krier					      */
/* @created :	02/02/2015					      */
/* @update :	25/02/2015					      */
/*--------------------------------------------------------------------*/

/*\* INCLUDES *\*/
#include "diff.h"
#include "filter.h"

#include "levenshtein.h"

#include <stdio.h>
#include <string.h>

/*
** int get_size_line(char *str, int beg)
**
**
** @param: char *str - string of lines
** @param: int beg - begin of the line
** @return: Integer - return the line size
*/
static int get_size_line(char *str, int beg)
{
  int end = beg;
  while (str[end] != '\0' && str[end++] != '\n');
  return end - 1;
}

/*
** int compare_files(char *str_file1, char *str_file2)
**
**
** @param: char *str_file1 - string of lines file one
** @param: char *str_file2 - string of lines file two
** @return: Integer - return comparaison value
*/
static int compare_files(char *str_file1, char *str_file2)
{
  unsigned int i = 0, j = 0;
  unsigned int size1, size2;
  int cpt_cmp = 0;
  int cpt_lev = 0;

  int res_cmp, res_lev;

  unsigned int len1 = strlen(str_file1);
  unsigned int len2 = strlen(str_file2);

  while (len1 > i || len2 > j)
    {
      size1 = get_size_line(str_file1, i);
      size2 = get_size_line(str_file2, j);
      res_cmp = strncmp(str_file1 + i, str_file2 + j, size1 < size2 ? size1 : size2);
      str_file1[i + size1] = 0;
      str_file2[j + size2] = 0;
      res_lev = levenshtein(str_file1 + i, str_file2 + j);
      cpt_cmp += res_cmp;
      cpt_lev += res_lev;
      printf("check CMP: %d\ncheck LEV: %d\n", res_cmp, res_lev);
      i += size1 + 1;
      j += size2 + 1;
    }
  printf("\nValue CMP: %d\nValue LEV: %d\n", cpt_cmp, cpt_lev);
  return cpt_lev;
}

/*
** int diff(char *str_file1, char *str_file2)
** This function allow to get difference value between two files 
**
** @param: char *str_file1 - string of lines file one
** @param: char *str_file2 - string of lines file two
** @return: Integer - return comparaison value
*/
int diff(char *str_file1, char *str_file2)
{
  str_file1 = filter_space(str_file1);
  str_file2 = filter_space(str_file2);

  str_file1 = filter_newline(str_file1);
  str_file2 = filter_newline(str_file2);

  return compare_files(str_file1, str_file2);
}
