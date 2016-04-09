
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
** Gets the number of words in a string.
**
** @param: string - the string of lines
** @return: Integer - return the number of words in a line
*/
static int	count_words(const char *string)
{
  int	cpt = 0;

  while (*string++)
    if (*string == ' ' || *string == '\t')
      ++cpt;
  return cpt + 1;
}

/*
** Set a stucture of words by structure of line.
**
** @param: struct_file - the structure of line
** @return: int - return zero if that worked
*/
int	set_array_words(s_line *struct_line)
{
  char *tmp_line;
  char *str1;
  int j;
  const char *delim = " \t\n";

  struct_line->nb_words = count_words(struct_line->line);
  if (!(struct_line->words = malloc(sizeof(s_word *) * (struct_line->nb_words + 1))))
    return -1;

  tmp_line = strdup(struct_line->line);

  for (j = 0, str1 = tmp_line; ; j++, str1 = NULL)
    {
      if (!(struct_line->words[j] = malloc(sizeof(s_word) + 1)))
	return -1;
      struct_line->words[j]->word = strtok(str1, delim);
      if (struct_line->words[j]->word == NULL)
	{
	  free(struct_line->words[j]);
	  struct_line->words[j] = NULL;
	  break;
	}
      struct_line->words[j]->size = strlen(struct_line->words[j]->word);
    }
  return 0;
}

/*
** Set a stucture of line by structure of file.
**
** @param: struct_file - the stucture of file
** @return: int - return zero if that worked
*/
 int	set_array_lines(s_file *struct_file)
{
  char *tmp_file;
  char *str1;
  int j;
  const char *delim = "\n";

  struct_file->nb_lines = count_lines(struct_file->file);
  if (!(struct_file->lines = malloc(sizeof(s_line *) * (struct_file->nb_lines + 1))))
    return -1;

  tmp_file = strdup(struct_file->file);

  for (j = 0, str1 = tmp_file; ; j++, str1 = NULL)
    {
      if (!(struct_file->lines[j] = malloc(sizeof(s_line) + 1)))
	return -1;
      struct_file->lines[j]->line = strtok(str1, delim);
      if (struct_file->lines[j]->line == NULL)
	{
	  free(struct_file->lines[j]);
	  struct_file->lines[j] = NULL;
	  break;
	}
      struct_file->lines[j]->size = strlen(struct_file->lines[j]->line);
    }
  for (j = 0; struct_file->lines[j]; ++j)
    set_array_words(struct_file->lines[j]);
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

  if (!(struct_file = malloc(sizeof(s_file) + 1)))
    return NULL;
  struct_file->lines = NULL;
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
  int	i, j;
  if (struct_file)
    {
      if (struct_file->lines)
	for (i = 0; struct_file->lines[i]; ++i)
	  {
	    if (struct_file->lines[i]->words)
	      {
		for (j = 0; struct_file->lines[i]->words[j]; ++j)
		  {
		    free(struct_file->lines[i]->words[j]);
		  }
		free(struct_file->lines[i]->words);
	      }
	    free(struct_file->lines[i]);
	  }
      free(struct_file->file);
      free(struct_file->lines);
      free(struct_file);
      struct_file = NULL;
    }
}
