
#pragma once

typedef struct	t_file
{
  unsigned int	size;
  unsigned int	nb_lines;
  char		*file;
  char		*tmp_file;
  struct t_line	**lines;
} s_file;

typedef struct	t_line
{
  unsigned int	size;
  unsigned int	nb_words;
  char		*line;
  char		*tmp_line;
  struct t_word	**words;
} s_line;

typedef struct	t_word
{
  unsigned int	size;
  char		*word;
} s_word;

/*
** Initializes a new structure, containing file informations.
**
** @param: str_file - string representing a file
** @return: s_file * - returns the new file structure
** or -1 in case of failure
*/
s_file	*init_file_handler(char *str_file);

/*
** Destroy a file structure
**
** @param: struct_file - file structure
** @return: void
*/
void	destroy_file_handler(s_file *struct_file);
