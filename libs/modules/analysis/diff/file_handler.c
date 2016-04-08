
/* INCLUDES */
#include "file_handler.h"
#include "filter.h"

#include <string.h>

#include <stdio.h>
#include <stdlib.h>

/*
** Gets the number of line in a file.
**
** @param: file - the file
** @return: Integer - return the number of words in a line
*/
static unsigned int	count_lines(const char *file)
{
  unsigned int	cpt = 0;

  while (*file++)
    if (*file == '\n')
      ++cpt;
  return cpt + 1;
}

/*
** Gets an array of line in file.
**
** @param: file - the file
** @return: Char** - return an array of lines
*/
static int	set_array_lines(s_file *struct_file)
{
  char *str1;
  int j;
  const char *delim = "\n";

  struct_file->nb_lines = count_lines(struct_file->file);
  if (!(struct_file->lines = malloc(sizeof(char *) * (struct_file->nb_lines + 1))))
    return -1;

  for (j = 0, str1 = struct_file->file; ; j++, str1 = NULL)
    {
      struct_file->lines[j] = strtok(str1, delim);
      if (struct_file->lines[j] == NULL)
	break;
    }
  return 0;
}

/*
** Initialize a new structure, this contains file informations.
**
** @param: str_file - the string of file
** @return: s_file * - return the new structure of file
*/
s_file	*init_file_handler(char *str_file)
{
  s_file *struct_file;

  if (!str_file)
    return NULL;

  str_file = filter_space(str_file);
  str_file = filter_newline(str_file);


  if (!(struct_file = malloc(sizeof(s_file *) + 1)))
    return NULL;
  if (!(struct_file->file = strdup(str_file)))
    return NULL;
  struct_file->size = strlen(str_file);
  if (set_array_lines(struct_file) < 0)
    return NULL;
  return struct_file;
}

/*
** Destroy the structure of file.
**
** @param: struct_file - the structure of file
** @return: void
*/
void	destroy_file_handler(s_file *struct_file)
{
  free(struct_file->file);
  free(struct_file->lines);
  free(struct_file);
  struct_file = NULL;
}
