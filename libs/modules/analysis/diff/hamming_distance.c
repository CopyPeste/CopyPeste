
/* INCLUDES */
#include <string.h>

/*
** It calculates the Hamming distance
** between two strings
**
** @param: char *str - string of lines file one
** @param: char *str - string of lines file two
** @param: int beg - begin of the line
** @return: Integer - return the line size
*/
int	hamming_distance(char *str1, char *str2, int size)
{
  int hm_distance = 0;
    
  if (strlen(str1) == strlen(str2))
    {
      for (int i = 0; i < size; i++)
	if (!(str1[i] == str2[i]))
	  ++hm_distance;
    }
  else
    hm_distance = -1;  
  return hm_distance;
}
