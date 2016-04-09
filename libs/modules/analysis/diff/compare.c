
#include "compare.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

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
 int	compare_arrays(s_word **words1, s_word **words2)
{
  int	result = 0;
  int	i, j;

  if (!words1 && !words2)
    return -1;
  for (i = 0; words1[i]; ++i)
    {
      for (j = 0; words2[j]; ++j)
	{
	  if (words1[i]->word && words2[j]->word
	      && words1[i]->size == words2[j]->size
	      && memcmp(words1[i]->word, words2[j]->word, words1[i]->size) == 0)
	    {
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
** @param: str_file1 - struct line containing the first line
** @param: str_file2 - struct line containing the second line
** @return: Integer - return comparison value in percentage
*/
int	compare_words_strings(const s_line *line1, const s_line *line2)
{
  int result = 0;

  if (!line1 || !line2)
    return -1;

  result = (line1->nb_words > line2->nb_words ?
    compare_arrays(line1->words, line2->words) :
  	 compare_arrays(line2->words, line1->words));

  if ((line1->nb_words > 0 || line2->nb_words > 0) && result >= 0)
    return ((result * 100) / (line1->nb_words > line2->nb_words ?
			      line1->nb_words : line2->nb_words));
  return -1;
}
