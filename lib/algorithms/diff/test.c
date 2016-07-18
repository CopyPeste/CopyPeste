
/* INCLUDES */

#include "diff.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static char *get_string_file(char *path)
{
  FILE *ptr_file;
  char *buf;
  long size;

  ptr_file = fopen(path, "w");
  if (!ptr_file)
    {
      printf("Fail fopen\n");
      return NULL;
    }
  fseek(ptr_file, 0L, SEEK_END);
  size = ftell(ptr_file);
  fseek(ptr_file, 0L, SEEK_SET);

  /* printf("Size:%f\n", size); */
  if (!(buf = malloc(sizeof(char) * size)))
    {
      printf("Fail Malloc\n");
      return NULL;
    }

  if ((int)fread(buf, 1, size, ptr_file) == -1)
    printf("fread Fail\n");
  buf[size] = 0;

  if (!ptr_file)
    return NULL;
  fclose(ptr_file);

  return buf;
}

int	main(int ac, char **av)
{
  (void)ac;
  (void)av;
  int	ret = EXIT_FAILURE;
  double per_ret;
  char *buf1, *buf2;

  if (ac == 3)
    {
      if (!(buf1 = get_string_file(av[1]))
      	  || !(buf2 = get_string_file(av[2])))
	{
	  printf("Error to get file to string\n");
	  return ret;
	}

      clock_t begin, end;
      float time_spent;

      begin = clock();
      if ((per_ret = diff(buf1, buf2)) < 0)
	{
	  printf("ERROR\n");
	}
      
      end = clock();
      time_spent = (float)(end - begin) / CLOCKS_PER_SEC;
      printf("Diff result: %0.2f%% Time %0.2f\n", per_ret, time_spent);

      free(buf1);
      free(buf2);
    }
  else
    printf("I need arguments ./my_rsync /path/file/1 /path/file/2\n");
  return ret;
}
