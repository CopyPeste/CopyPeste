
/* INCLUDES */
#include <string.h>

/*
** It calculates the Hamming distance of two strings
**
** @param: char *str - line of file one in string
** @param: char *str - line of file two in string
** @param: int beg - beginning of the line
** @return: Integer - return the hamming distance
*/
int	hamming_distance(char *str1, char *str2, int beg)
{
  int hm_distance = 0;

  if (strlen(str1) == strlen(str2))
    {
      for (int i = 0; i < beg; i++)
	if (!(str1[i] == str2[i]))
	  ++hm_distance;
    }
  else
    hm_distance = -1;
  return hm_distance;
}
