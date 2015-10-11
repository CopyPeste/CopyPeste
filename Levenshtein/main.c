/*--------------------------------------------------------------------*/
/*		     Epitech EIP 2017 groupe Copypeste		      */
/*								      */
/*			    Algo Levenshtein			      */
/* developed by :						      */
/* Edouard Marechal						      */
/* Amina Ourouba						      */
/*--------------------------------------------------------------------*/

#include "main.h"

void	readfile(char **file) {

  int i = 0;
  int j = 0;

  while (file[i] != NULL) {
    //    printf("%s\n", file[i]);
    i++;
  }
  initLevenshtein(file);
}

char	**openfile(char **file, char *openfile) {

  FILE *open;
  int carac;
  int i = 0;
  int j = 0;

  file = malloc(sizeof(char) * 8000000);
  *file = malloc(1042);

  open = fopen(openfile, "r+");
  carac = fgetc(open);
  while (carac > 0) {
    if (carac == 10) 
      {
	file[i][j] = 0;
	i++;
	file[i] = malloc(1042);
	j = 0;
      }
    else
      file[i][j++] = carac;
    carac = fgetc(open);
  }
  file[i] = NULL;
  return file;
}


int	main(int ac, char **av) {

  char **file;
  file = openfile(file, av[1]);
  readfile(file);
}
