
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

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
** Gets words in a string, begin at Beg.
**
** @param: string - the string of lines
** @param: beg - beginning to read
** @return: Char* - return the next word
*/
static char	*get_next_word(const char *string, int *beg)
{
  int cpt = *beg;
  char *word;

  while (string[cpt] != ' ' && string[cpt] != '\t'
	 && string[cpt] != '\n' && string[cpt] != '\0')
    cpt++;
  if (cpt == *beg)
    return NULL;

  if (!(word = malloc(sizeof(char) * (cpt - *beg + 1))))
    return NULL;
  strncpy(word, string, cpt - *beg);
  word[cpt] = 0;
  *beg = cpt;
  return word;
}

/*
** Gets an array of words in string.
**
** @param: string - the string of lines
** @return: Char** - return an array of words
*/
static char	**get_array_words(const char *string)
{
  char **words;
  int nb_words = count_words(string);
  int len = 0;

  if (!(words = malloc(sizeof(char *) * nb_words)))
    return NULL;
  for (int i = 0; (words[i] = get_next_word(string, &len)); ++i);
  return words;
}

/*
** Gets the percentage diference between two files,
** word by word.
** Return the percentage difference between two strings,
** word by word algorithm.
**
** @param: str_file1 - string containing the first file
** @param: str_file2 - string containing the second file
** @return: Integer - return comparison value in percentage
*/
int	compare_words_strings(const char *string1, const char *string2)
{
  char **words_string1, **words_string2;
  int i, j;
  int result = 0;

  if (!string1 || !string2)
    return -1;
  if (!(words_string1 = get_array_words(string1))
      || !(words_string2 = get_array_words(string2)))
    return -1;

  for (i = 0; words_string1[i]; ++i)
    {
      for (j = 0; words_string2[j]; ++j)
	if (strcmp(words_string1[i], words_string2[j]) == 0)
	  ++result;
      free(words_string1[i]);
    }

  for (int h = 0; words_string2[h]; ++h)
    free(words_string2[h]);
  free(words_string1);
  free(words_string2);

  return (result / (i > j ? i : j)) * 100;
}
