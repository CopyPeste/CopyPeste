
#include "compare.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/*
** Gets the percentage of difference between two structures words,
** compares word by word.
** Return the number of same word between words of structure,
** word by word algorithm.
**
** @param: words1 - structure of words one
** @param: words2 - structure of words two
** @return: Integer - returnx the comparison value
** or -1 in case of null words
*/
static
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
** Gets the percentage of difference between two structures of line,
** compares word by word.
** Return the percentage of difference between two strings,
** word by word algorithm.
**
** @param: line1 - structure of line one
** @param: line2 - structure of line two
** @return: Integer - returns the comparison value in percentage
** or -1 in case of null strings
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
