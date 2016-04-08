
#pragma once

typedef struct	t_file
{
  unsigned int	size;
  unsigned int	nb_lines;
  char		*file;
  char		**lines;
} s_file;


/*
** Initialize a new structure, this contains file informations.
**
** @param: str_file - the string of file
** @return: s_file * - return the new structure of file
*/
s_file	*init_file_handler(char *str_file);

/*
** Destroy the structure of file.
**
** @param: struct_file - the structure of file
** @return: void
*/
void	destroy_file_handler(s_file *struct_file);
