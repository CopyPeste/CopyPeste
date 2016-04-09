
#pragma once

typedef struct	t_file
{
  unsigned int	size;
  unsigned int	nb_lines;
  char		*file;
  struct t_line	**lines;
} s_file;

typedef struct	t_line
{
  unsigned int	size;
  unsigned int	nb_words;
  char		*line;
  struct t_word	**words;
} s_line;

typedef struct	t_word
{
  unsigned int	size;
  char		*word;
} s_word;


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
