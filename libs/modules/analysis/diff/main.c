/*--------------------------------------------------------------------*/
/*		     Epitech EIP 2017 groupe Copypeste		      */
/*								      */
/*			    Algo diff				      */
/*								      */
/* @by :	Guillaume Krier					      */
/* @created :	02/02/2015					      */
/* @update :	25/02/2015					      */
/*--------------------------------------------------------------------*/

#include "diff.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>


int	main()
{
  char *str_one;
  char *str_two;
  int	ret;

  char test1[] = "my beautiful\ntest work !";
  char test2[] = "my second\n\n\ntest work to !";

  str_one = strdup(test1);
  str_two = strdup(test2);
  
  ret = diff(str_one, str_two);
  printf("Result Dif: %d\n", ret);
  return ret;
}
