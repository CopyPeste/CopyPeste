
/* INCLUDES */
#include <string.h>

#include <stdio.h>
#include <stdlib.h>

#include "file_handler.h"
#include "filter.h"


/*
** Gets the number of line in a file.
**
** @param: file - the file
** @return: Integer - returns the number of words in a line
*/
static
unsigned int	count_lines(const char *file)
{
  unsigned int	cpt = 0;

  if (*file == '\0')
    return cpt;
  while (*file++)
    cpt += (*file == '\n');
  --file;
  return cpt + (*file != '\n');
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
  int	cpt = 0;
  
  do {
    while (*string == ' ' || *string == '\t')
      ++string;
    if (*string == '\0')
      return cpt;
    while (*string != ' ' && *string != '\t' && *string != '\0')
      ++string;
    ++cpt;
  } while (*string != '\0');
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
  char *str1, *token;
  int j;
  const char *delim = " \t\n";

  struct_line->nb_words = count_words(struct_line->line);
  if (!(struct_line->words = malloc(sizeof(s_word *) * (struct_line->nb_words + 1))))
    return -1;
  struct_line->tmp_line = strdup(struct_line->line);

  str1 = struct_line->tmp_line;
  token = strtok(str1, delim);
  for (j = 0; token; j++) {
    if (!(struct_line->words[j] = malloc(sizeof(s_word))))
      return -1;
    struct_line->words[j]->word = token;
    struct_line->words[j]->size = strlen(struct_line->words[j]->word);
    struct_line->words[j]->at = j;
    token = strtok(NULL, delim);
  }
  struct_line->words[j] = NULL;
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
  char *str1, *token;
  int j;
  const char *delim = "\n";

  struct_file->nb_lines = count_lines(struct_file->file);
  if (!(struct_file->lines = malloc(sizeof(s_line *) * (struct_file->nb_lines + 1))))
    return -1;
  struct_file->tmp_file = strdup(struct_file->file);
  str1 = struct_file->tmp_file;
  token = strtok(str1, delim);
  for (j = 0; token; j++) {
    if (!(struct_file->lines[j] = malloc(sizeof(s_line))))
      return -1;
    struct_file->lines[j]->line = token;
    struct_file->lines[j]->size = strlen(struct_file->lines[j]->line);
    token = strtok(NULL, delim);
  }
  struct_file->lines[j] = NULL;

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

  if (!(struct_file = malloc(sizeof(s_file))))
    return NULL;
  struct_file->lines = NULL;
  if (!(struct_file->file = strdup(str_file)))
    return NULL;
  struct_file->file = filter_space(struct_file->file);
  struct_file->file = filter_newline(struct_file->file); 
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
		  free(struct_file->lines[i]->words[j]);
		free(struct_file->lines[i]->words);
	      }
	    free(struct_file->lines[i]->tmp_line);
	    free(struct_file->lines[i]);
	  }
      free(struct_file->tmp_file);
      free(struct_file->file);
      free(struct_file->lines);
      free(struct_file);
      struct_file = NULL;
    }
}
