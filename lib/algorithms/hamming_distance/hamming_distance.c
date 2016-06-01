
/* INCLUDES */
#include <string.h>

/*
** Calculates the Hamming distance of two strings
**
** @param: char *str1 - first string to compare
** @param: char *str2 - second string to compare
** @return: Integer - return the hamming distance between str1 and str2
*/
int	hamming_distance(const char *str1, const char *str2)
{
  int hm_distance = 0, i;

  if (strlen(str1) != strlen(str2))
    return -1;
  for (i = 0; str1[i]; i++)
    hm_distance += str1[i] != str2[i];
  return hm_distance;
}
