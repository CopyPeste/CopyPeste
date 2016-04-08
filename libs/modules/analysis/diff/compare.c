
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <time.h>

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
** Gets an array of words in string.
**
** @param: string - the string of lines
** @return: Char** - return an array of words
*/
static char	**get_array_words(char *string)
{
  char **words;
  char *str1;
  int nb_words = count_words(string);
  int j;
  const char *delim = " \t\n";

  if (!(words = malloc(sizeof(char *) * (nb_words + 1))))
    return NULL;

  for (j = 0, str1 = string; ; j++, str1 = NULL) {
    words[j] = strtok(str1, delim);
    if (words[j] == NULL)
      break;
  }
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
** @return: Integer - return comparison value
*/
int	compare_arrays(char **words_string1, char **words_string2)
{
  int	result = 0;
  int	len_wrd1, len_wrd2;

  for (int i = 0; words_string1[i]; ++i)
    {
      for (int j = 0; words_string2[j]; ++j)
	{
	  len_wrd1 = strlen(words_string1[i]);
	  len_wrd2 = strlen(words_string2[j]);
	  if (len_wrd1 == len_wrd2
	      && memcmp(words_string1[i], words_string2[j],
	  	     len_wrd1 < len_wrd2 ? len_wrd1 : len_wrd2) == 0)
	    {
	  /* if (strcmp(words_string1[i], words_string2[j]) == 0) */
	  /*   { */
	      ++result;
	      break;
	    }
	}
    }
  return result;
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
int	compare_words_strings(char *string1, char *string2)
{
  char **words_string1, **words_string2;
  char *tmp_string1, *tmp_string2;
  int i, j;
  int result = 0;

  if (!string1 || !string2)
    return -1;

  if (!(tmp_string1 = strdup(string1))
	|| !(words_string1 = get_array_words(tmp_string1))
	|| !(tmp_string2 = strdup(string2))
	|| !(words_string2 = get_array_words(tmp_string2)))
    return -1;

  for (i = 0; words_string1[i]; ++i);
  for (j = 0; words_string2[j]; ++j);

  if (i > j)
    result = compare_arrays(words_string1, words_string2);
  else
    result = compare_arrays(words_string2, words_string1);

  free(words_string1);
  free(words_string2);
  free(tmp_string1);
  free(tmp_string2);

  return ((result * 100) / (i > j ? i : j));
}
