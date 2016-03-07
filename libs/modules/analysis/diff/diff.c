
/* INCLUDES */
#include "filter.h"
#include "compare.h"

#include <string.h>

/*
** This function gets size of file string line.
**
** @param: str - string of lines.
** @param: beg - begin of the line.
** @return: Integer - return the line size.
*/
static int get_size_line(const char *str, int beg)
{
  int end = beg;
  while (str[end] != '\0' && str[end] != '\n')
    end++;
  return (end - beg);
}

/*
** This function allows to get the difference value between two files
** line by line.
** Return the percentage of difference to obtain the same file
** by word by word algorithm.
**
** @param: str_file1 - The string of the first file.
** @param: str_file2 - The string of the second file.
** @return: Integer - return comparaison value in percentage.
*/
static double compare_files_lev_percent(char *str1, char *str2)
{
  unsigned int len1, len2;
  unsigned int i = 0, j = 0;
  unsigned int size1, size2;
  double prcent = 0;
  int nb_line = 0;

  if (!str_file1 || !str_file2)
    return -1;
  len1 = strlen(str_file1);
  len2 = strlen(str_file2);

  while (len1 > i && len2 > j)
    {
      size1 = get_size_line(str_file1, i);
      size2 = get_size_line(str_file2, j);

      str_file1[i + size1] = 0;
      str_file2[j + size2] = 0;

      prcent += compare_words_strings(str_file1 + i, str_file2 + j);
      
      i += size1 + 1;
      j += size2 + 1;
      ++nb_line;
    }

  if (nb_line > 0)
    prcent /= nb_line;
  return prcent;
}

/*
** This function allows to get the difference value between two files
** line by line.
** Remove usless space and newline.
** Return the percentage of difference to obtain the same file.
**
** @param: str_file1 - The string of the first file.
** @param: str_file2 - The string of the second file.
** @return: Integer - Its return the result of compare in percentage.
*/

double diff(char *str_file1, char *str_file2)
{
  str_file1 = filter_space(str_file1);
  str_file2 = filter_space(str_file2);

  str_file1 = filter_newline(str_file1);
  str_file2 = filter_newline(str_file2);

  return compare_files_lev_percent(str_file1, str_file2);
}
