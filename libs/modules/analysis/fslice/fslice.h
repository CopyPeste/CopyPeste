
#pragma once


typedef struct	t_result
{
  int	line;
  int	prcent_rst;
}	s_result;

/* PROTOTYPES */

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
/* double fslice(char *str_block, char *str_file); */
s_result *fslice(char *str_block, char *str_file);

