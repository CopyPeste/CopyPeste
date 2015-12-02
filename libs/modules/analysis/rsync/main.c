/*--------------------------------------------------------------------*/
/*		     Epitech EIP 2017 groupe Copypeste		      */
/*								      */
/*			    Algo Levenshtein			      */
/*								      */
/* @by :	Guillaume Krier					      */
/* @created :	19/09/2015					      */
/* @update :	19/09/201					      */
/*--------------------------------------------------------------------*/

/*\* INCLUDES *\*/
#include <stdlib.h>
#include <stdio.h>
#include "copypeste.h"
#include "compare.h"

/*\* GLOBAL VARIABLES *\*/
int verbose_error = TRUE;
int verbose_message = TRUE;

int	main(int ac, char **av)
{
  int16	ret = EXIT_FAILURE;

  if (ac == 3)
    ret = compare_files_match(av[1], av[2], SIZE_RD_CHAR);
  else
    {
      CP_message("I need arguments ./my_rsync /path/file/1 /path/file/2\n");
      /* ret = compare_files_match("", ""); */
    }
  CP_message_arg("Resultat: %s\n", ret == 1 ? "FAIL" : "SIMILARE");
  return ret;
}

