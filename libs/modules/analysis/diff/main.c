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

#define SIZE_FILE 4000


int	main(int ac, char **av)
{
  char *str_one;
  char *str_two;
  int	ret;

  (void)ac;
  /* char test1[] = "my beautiful\ntest work !"; */
  /* char test2[] = "my beautiful\ntest1 work !"; */
  /* char test2[] = "my second\n\n\ntest work to !"; */


  FILE *ptr_file1, *ptr_file2;
  char *buf1, *buf2;
  int size1, size2;

  ptr_file1 = fopen(av[1],"r");
  ptr_file2 = fopen(av[2],"r");
  if (!ptr_file1 || !ptr_file2)
    {
      printf("Fail fopen");
      return 1;
    }
  fseek(ptr_file1, 0L, SEEK_END);
  size1 = ftell(ptr_file1);
  fseek(ptr_file1, 0L, SEEK_SET);
  fseek(ptr_file2, 0L, SEEK_END);
  size2 = ftell(ptr_file2);
  fseek(ptr_file2, 0L, SEEK_SET);

  buf1 = malloc(sizeof(char) * size1);
  buf2 = malloc(sizeof(char) * size2);

  if (!buf1 || !buf2)
    return 1;

  if ((int)fread(buf1, 1, size1, ptr_file1) == -1)
    printf("fread Fail");
  if ((int)fread(buf2, 1, size2, ptr_file2) == -1)
    printf("fread Fail");

  buf1[size1] = 0;
  buf2[size2] = 0;

  fclose(ptr_file1);
  fclose(ptr_file2);

  str_one = strdup(buf1);
  str_two = strdup(buf2);
  
  ret = diff(str_one, str_two);
  printf("Result Dif: %d\n", ret);
  return ret;
}
