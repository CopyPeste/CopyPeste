
/* INCLUDES */
#include <string.h>

#include <stdio.h>
#include <stdlib.h>

#include "file_handler.h"
#include "filter.h"
#include "my_strtok.h"


/*
** Gets the number of line in a file.
**
** @param: file - the file
** @return: Integer - returns the number of words in a line
*/
static
unsigned int	count_lines(const char *file)
{
  unsigned int	cpt = 1;

  while (*file++)
    cpt += (*file == '\n');
   return cpt;
}



/*
** Gets the number of words in a string.
**
** @param: string - the string of lines
** @return: Integer - returns the number of words in a line
*/
static
int	count_words(const char *string)
{
  int	cpt = 1;

  while (*string++)
    cpt += (*string == ' ' || *string == '\t');
  return cpt;
}

/*
** Puts a words stucture into a file structure.
**
** @param: struct_file - the line structure
** @return: int - returns zero in case of success, -1 if failure
*/
static
int	set_array_words(s_line *struct_line)
{
  char *str1;
  int j;
  const char *delim = " \t\n";

  struct_line->nb_words = count_words(struct_line->line);
  if (!(struct_line->words = malloc(sizeof(s_word *) * (struct_line->nb_words + 1))))
    return -1;

  struct_line->tmp_line = strdup(struct_line->line);

  for (j = 0, str1 = struct_line->tmp_line; ; j++, str1 = NULL)
    {
      if (!(struct_line->words[j] = malloc(sizeof(s_word) + 1)))
	return -1;
      struct_line->words[j]->word = my_strtok(str1, delim);
      if (struct_line->words[j]->word == NULL)
	{
	  free(struct_line->words[j]);
	  struct_line->words[j] = NULL;
	  break;
	}
      struct_line->words[j]->size = strlen(struct_line->words[j]->word);
      struct_line->words[j]->at = j;
    }
  return 0;
}

/*
** Puts a line stucture into a file structure
**
** @param: struct_file - the file stucture
** @return: int - returns zero in case of success, -1 if failure
*/
static
int	set_array_lines(s_file *struct_file)
{
  char *str1;
  int j;
  int	count_line = 0;
  const char *delim = "\n";

  struct_file->nb_lines = count_lines(struct_file->file);
  if (!(struct_file->lines = malloc(sizeof(s_line *) * (struct_file->nb_lines + 1))))
    return -1;

  struct_file->tmp_file = strdup(struct_file->file);

  for (j = 0, str1 = struct_file->tmp_file; ; j++, str1 = NULL)
    {
      if (!(struct_file->lines[j] = malloc(sizeof(s_line) + 1)))
	return -1;

      /* Count number of delimitation */
      count_line += count_delim(str1, delim),
      struct_file->lines[j]->line = my_strtok(str1, delim);
      if (struct_file->lines[j]->line == NULL)
	{
	  free(struct_file->lines[j]);
	  struct_file->lines[j] = NULL;
	  break;
	}
      struct_file->lines[j]->size = strlen(struct_file->lines[j]->line);
      struct_file->lines[j]->at = (j + count_line) + 1;
    }

  for (j = 0; struct_file->lines[j]; ++j)
    set_array_words(struct_file->lines[j]);
  return 0;
}

/*
** Initializes a new structure, containing file informations.
**
** @param: str_file - string representing a file
** @return: s_file * - returns the new file structure
** or -1 in case of failure
*/
s_file	*init_file_handler(char *str_file)
{
  s_file *struct_file;

  if (!str_file)
    return NULL;

  str_file = filter_space(str_file);
  /* str_file = filter_newline(str_file); */ // Remove to find number of line

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
** Destroy a file structure
**
** @param: struct_file - file structure
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
	    free(struct_file->lines[i]->tmp_line);
	  }
      free(struct_file->tmp_file);
      free(struct_file->file);
      free(struct_file->lines);
      free(struct_file);
      struct_file = NULL;
    }
}
