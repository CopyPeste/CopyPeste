
/* INCLUDES */

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "fslice.h"
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
/* static */
int find_line_in_block(const s_file *struct_block, const s_file *struct_file, int line)
{
  unsigned int i = 0;
  unsigned int j = line;
  int result = 0;
  int tmp_result;

  if (!struct_file || !struct_block)
    return -1;

  while (struct_block->lines[i] && i < struct_block->nb_lines
	 && struct_file->lines[j + i] && (j + i) < struct_file->nb_lines)
    {
      tmp_result = compare_words_strings_inline(struct_file->lines[j + i], struct_block->lines[i]);
      result += tmp_result;
      ++i;
    }

  if (result < 0)
    result = 0;
  result /= i;

  return result;
}

/*
** Gets similarity between block code and files
** block per block
**
** @param: struct_block - block structure
** @param: struct_file - file structure
** @return: Integer - returns if is similarity 1 or 0
** or -1 in case of null file
*/
static
int compare_block_in_file(const s_file *struct_block, const s_file *struct_file, s_result *result)
{
  unsigned int i = 0;
  int	tmp_result = 0;
  int	ret = -1;

  if (!struct_block || !struct_file)
    return ret;

  while (struct_file->lines[i])
    {
      tmp_result = find_line_in_block(struct_block, struct_file, i);
      if (tmp_result > result->prcent_rst)
      	{
      	  result->prcent_rst = tmp_result;
	  result->line = struct_file->lines[i]->at;
	  ret = 0;
      	}
      ++i;
    }

  /* if ((struct_block->nb_lines > 0 || struct_file->nb_lines > 0) && result->prcent_rst > 0) */
  /*   result->prcent_rst = (result->prcent_rst * 100) */
  /*     / (struct_block->nb_lines > struct_file->nb_lines ? */
  /* 	 struct_block->nb_lines : struct_file->nb_lines); */
  return ret;
}

/*
** Gets the percentage of difference between two files,
** block by block.
** Return the percentage of difference to obtain the same file,
** with a word by word algorithm.
**
** @param: struct_file1 - first file structure
** @param: struct_file2 - second the file structure
** @return: Integer - returns the comparison value in percentage
** or -1 in case of null file
*/


/*
** Gets the difference between two files,
** line by line.
** Remove useless characters in files.
** Return the percentage of difference to obtain the same file.
**
** @param: str_block - string containing the block of code
** @param: str_file - string containing the file
** @return: Integer - returns the comparison result in percentage
** or -1 in case of error
*/
int fslice(char *str_block, char *str_file, s_result *result)
{
  s_file *struct_block, *struct_file;
  int	ret = -1;

  if (!(struct_block = init_file_handler(str_block))
      || !(struct_file = init_file_handler(str_file)))
    return ret;

  if (struct_block->size <= struct_file->size)
    {
      if ((ret = compare_block_in_file(struct_block, struct_file, result)) != 0)
	return ret;
    }

  destroy_file_handler(struct_block);
  destroy_file_handler(struct_file);
  return ret;
}
