/*--------------------------------------------------------------------*/
/*		     Epitech EIP 2017 groupe Copypeste		      */
/*								      */
/*			    Algo diff				      */
/*								      */
/* @by :	Guillaume Krier					      */
/* @created :	02/02/2015					      */
/* @update :	28/02/2015					      */
/*--------------------------------------------------------------------*/

/*\* INCLUDES *\*/
#include "diff.h"
#include "filter.h"
#include "hamming_distance.h"

#include "levenshtein.h"

#include <stdio.h>
#include <string.h>

/*
** It gets size of line in file string
**
** @param: char *str - string of lines
** @param: int beg - begin of the line
** @return: Integer - return the line size
*/
static int get_size_line(char *str, int beg)
{
  int end = beg;
  while (str[end] != '\0' && str[end] != '\n')
    end++;
  return (end - beg + 1);
}

/*
** It compares two files strings
**
** @param: char *str_file1 - string of lines file one
** @param: char *str_file2 - string of lines file two
** @return: Integer - return comparaison value
*/
static float compare_files_lev_percent(char *str_file1, char *str_file2)
{
  unsigned int len1, len2;
  unsigned int i = 0, j = 0;
  unsigned int size1, size2;
  int cpt_lev = 0;
  int res_lev;
  float prcent = 0;
  int nb_line = 0;

  if (!str_file1 || !str_file2)
    return -1;
  len1 = strlen(str_file1);
  len2 = strlen(str_file2);

  while (len1 > i || len2 > j)
    {
      size1 = get_size_line(str_file1, i);
      size2 = get_size_line(str_file2, j);

      str_file1[i + size1] = 0;
      str_file2[j + size2] = 0;

      res_lev = levenshtein(str_file1 + i, str_file2 + j);

      prcent += (float)((res_lev * 100) / (size1 > size2 ? size1 : size2));

      cpt_lev += res_lev;

      i += size1 + 1;
      j += size2 + 1;
      ++nb_line;
    }
  prcent /= nb_line;
  printf("Value LEV: %d\nValue pourcent %0.2f\n", cpt_lev, prcent);
  return prcent;
}

/*
** This function allows to get the difference value between two files 
**
** @param: char *str_file1 - string of lines file one
** @param: char *str_file2 - string of lines file two
** @return: Integer - return comparaison value
*/
float diff(char *str_file1, char *str_file2)
{
  str_file1 = filter_space(str_file1);
  str_file2 = filter_space(str_file2);

  str_file1 = filter_newline(str_file1);
  str_file2 = filter_newline(str_file2);

  return compare_files_lev_percent(str_file1, str_file2);
}
