
/* INCLUDES */
#include "diff.h"
#include "compare.h"

#include "file_handler.h"

#include <string.h>

#include <stdio.h>

#include <time.h>

/*
** This function return one if line into have a similarity in file
** else return zero
**
** @param: line - the string of lines
** @param: struct_file - struct of file
** @return: Integer - return percentage of similarity
*/
static int find_line_in_file(char *line, s_file *struct_file, int at)
{
  unsigned int i = (at - MAX_GAP) < 0 ? 0 : (at - MAX_GAP);
  
  if (!line || !struct_file)
    return -1;

  while (i < struct_file->nb_lines && i < (unsigned int)(at + MAX_GAP))
    {
      if (compare_words_strings(line, struct_file->lines[i]) == 100)
	return 1;
      ++i;
    }
  return 0;
}

/*
** This function gets the percentage of similarity between 2 files
** line per line
**
** @param: struct_file - struct of file one
** @param: struct_file - struct of file two
** @return: Integer - return percentage of similarity
*/
int compare_lines_in_file(s_file *struct_file1, s_file *struct_file2)
{
  unsigned int i = 0;
  int result = 0;

  if (!struct_file1 || !struct_file2)
    return -1;

  while (struct_file1->lines[i])
    {
      result += find_line_in_file(struct_file1->lines[i], struct_file2, i);
      ++i;
    }

  if (struct_file1->nb_lines > 0 || struct_file1->nb_lines > 0)
    result = (result * 100)
      / (struct_file1->nb_lines > struct_file2->nb_lines ?
	 struct_file1->nb_lines : struct_file2->nb_lines);
  return result;
}

/*
** This function gets the difference between two files,
** line by line.
** Return the percentage of difference to obtain the same file,
** with word by word algorithm.
**
** @param: str_file1 - the string of the first file
** @param: str_file2 - the string of the second file
** @return: Integer - return comparaison value in percentage
*/
double compare_files_percent(s_file *struct_file1, s_file *struct_file2)
{
  unsigned int i = 0;
  double prcent = 0;

  if (!struct_file1 || !struct_file1)
    return -1;

  while (struct_file1->lines[i] && struct_file2->lines[i])
    {
      prcent += compare_words_strings(struct_file1->lines[i], struct_file2->lines[i]);
      ++i;
    }

  if (struct_file1->nb_lines > 0 || struct_file1->nb_lines > 0)
    prcent /= struct_file1->nb_lines > struct_file2->nb_lines ?
      struct_file1->nb_lines : struct_file2->nb_lines;
  return prcent;
}

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

double diff(char *str_file1, char *str_file2)
{
  s_file *struct_file1, *struct_file2;
  int	ret = -1/* , ret2 = -1 */;

  if (!(struct_file1 = init_file_handler(str_file1))
      || !(struct_file2 = init_file_handler(str_file2)))
    return ret;

  ret = (struct_file1->size >= struct_file2->size ?
	 compare_lines_in_file(struct_file1, struct_file2) :
	 compare_lines_in_file(struct_file2, struct_file1));

  /* ret2 = compare_files_percent(struct_file1, struct_file2); */

  /* printf("RET1 [%d%%]\nRET2 [%d%%]\n", ret, ret2); */
  /* printf("RET1 [%d%%]\n", ret); */


  destroy_file_handler(struct_file1);
  destroy_file_handler(struct_file2);
  return ret;
}
