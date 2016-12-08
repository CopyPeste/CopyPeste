
/* INCLUDES */

#include <string.h>
#include <stdio.h>
#include <time.h>

#include "diff.h"
#include "compare.h"
#include "file_handler.h"

/*
** Returns one if line is similar to another line in file.
** Else returns zero
**
** @param: line - structure of line
** @param: struct_file - structure of file
** @param: at - line at begin research
** @return: Integer - return if line is similar to another line if file
** or -1 in case of null line or file
*/
static
int find_line_in_file(const s_line *line, const s_file *struct_file, int at)
{
  unsigned int i = (at - MAX_GAP) < 0 ? 0 : (at - MAX_GAP);

  if (!line || !struct_file || !struct_file->lines)
    return -1;

  while (struct_file->lines[i] && i < (unsigned int)(at + MAX_GAP)
	 && i < struct_file->nb_lines)
    {
      if (!struct_file->lines[i])
	return -1;
      if (compare_words_strings(line, struct_file->lines[i]) == 100)
      	return 1;
      ++i;
    }
  return 0;
}

/*
** Gets the percentage of similarity between 2 files
** line per line
**
** @param: struct_file - first file structure
** @param: struct_file - second file structure
** @return: Integer - returns the percentage of similarity
** or -1 in case of null file
*/
static
int compare_lines_in_file(const s_file *struct_file1, const s_file *struct_file2)
{
  unsigned int i = 0;
  int result = 0;

  if (!struct_file1 || !struct_file2)
    return -1;
  while (struct_file1->lines[i] && i < struct_file1->nb_lines)
    {
      result += find_line_in_file(struct_file1->lines[i], struct_file2, i);
      ++i;
    }

  if ((struct_file1->nb_lines > 0 || struct_file1->nb_lines > 0) && result > 0)
    result = (result * 100)
      / (struct_file1->nb_lines > struct_file2->nb_lines ?
	 struct_file1->nb_lines : struct_file2->nb_lines);
  return result;
}

/*
** Gets the percentage of difference between two files,
** line by line.
** Return the percentage of difference to obtain the same file,
** with a word by word algorithm.
**
** @param: struct_file1 - first file structure
** @param: struct_file2 - second the file structure
** @return: Integer - returns the comparison value in percentage
** or -1 in case of null file
*/
static __attribute__((unused))
int compare_files_percent(const s_file *struct_file1, const s_file *struct_file2)

{
  unsigned int i = 0;
  int prcent = 0;

  if (!struct_file1 || !struct_file1)
    return -1;

  while (struct_file1->lines[i] && struct_file2->lines[i]
	 && i < struct_file1->nb_lines && i < struct_file2->nb_lines)
    {
      prcent += compare_words_strings(struct_file1->lines[i], struct_file2->lines[i]);
      ++i;
    }

  if ((struct_file1->nb_lines > 0 || struct_file1->nb_lines) > 0 && prcent >= 0)
    prcent /= struct_file1->nb_lines > struct_file2->nb_lines ?
      struct_file1->nb_lines : struct_file2->nb_lines;
  return prcent;
}

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
double diff(char *str_file1, char *str_file2)
{
  s_file *struct_file1, *struct_file2;
  int	ret = -1;

  if (!(struct_file1 = init_file_handler(str_file1))
      || !(struct_file2 = init_file_handler(str_file2)))
    return ret;

  ret = (struct_file1->size >= struct_file2->size ?
  	 compare_lines_in_file(struct_file2, struct_file1) :
  	 compare_lines_in_file(struct_file1, struct_file2));
  /* ret = compare_files_percent(struct_file1, struct_file2); */

  destroy_file_handler(struct_file1);
  destroy_file_handler(struct_file2);
  return ret;
}
