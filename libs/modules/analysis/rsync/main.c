/*--------------------------------------------------------------------*/
/*		     Epitech EIP 2017 groupe Copypeste		      */
/*								      */
/*			    Algo Rsync				      */
/*								      */
/* @by :	Guillaume Krier					      */
/* @created :	19/09/2015					      */
/* @update :	29/02/2015					      */
/*--------------------------------------------------------------------*/

/*\* INCLUDES *\*/
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "rsync.h"

#include <time.h>

static char *get_string_file(char *path)
{
  FILE *ptr_file;
  char *buf;
  int size;

  ptr_file = fopen(path, "r");
  if (!ptr_file)
    {
      printf("Fail fopen");
      return NULL;
    }
  fseek(ptr_file, 0L, SEEK_END);
  size = ftell(ptr_file);
  fseek(ptr_file, 0L, SEEK_SET);

  buf = malloc(sizeof(char) * size);
  if (!buf)
    return NULL;

  if ((int)fread(buf, 1, size, ptr_file) == -1)
    printf("fread Fail");
  buf[size] = 0;

  fclose(ptr_file);

  return buf;
}

int	main(int ac, char **av)
{
  int	ret = EXIT_FAILURE;
  char *buf1, *buf2;

  if (ac == 3)
    {
      if (!(buf1 = get_string_file(av[1]))
	  || !(buf2 = get_string_file(av[2])))
	return ret;

      clock_t begin, end;
      float time_spent;

      begin = clock();
      ret = rsync(buf1, buf2, SIZE_RD_CHAR);
      end = clock();
      time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
      printf("RSync result: %s Time %0.2f\n", ret == 0 ? "EQUAL" : "FAIL", time_spent);

      begin = clock();
      ret = rsync_checksum(buf1, buf2, SIZE_RD_CHAR);
      end = clock();
      time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
      printf("Checksum result: %s Time %0.2f\n", ret == 0 ? "EQUAL" : "FAIL", time_spent);

      free(buf1);
      free(buf2);

    }
  else
    printf("I need arguments ./my_rsync /path/file/1 /path/file/2\n");
  return ret;
}

