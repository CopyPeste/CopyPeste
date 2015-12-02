/*--------------------------------------------------------------------*/
/*		     Epitech EIP 2017 groupe Copypeste		      */
/*								      */
/*			    Algo Levenshtein			      */
/* developed by :						      */
/* Edouard Marechal						      */
/* Amina Ourouba						      */
/* Jeremy Pouyet						      */
/*--------------------------------------------------------------------*/

#include <string.h>
#include <stdint.h>
#include "levenshtein.h"

int			levenshtein(char *str1, char *str2)
{
  static int32_t	matrice[MAXWORD][MAXWORD];
  static bool_t		hasBeenInit = FALSE;
  int32_t		i = 0;
  int32_t		j = 0;

  if (hasBeenInit == FALSE)
    {
      while (i < MAXWORD)
	{
	  matrice[i][0] = i;
	  matrice[0][i] = i;
	  ++i;
	}
      hasBeenInit = TRUE;
    }

  /* algo complet */
  for (i = 0; str1[i]; i++) 
    {
      for (j = 0; str2[j]; j++) 
	{
	  if (str1[i] == str2[j])
	    matrice[i + 1][j + 1] = matrice[i][j];
	  else if (matrice[i][j + 1] <= matrice[i + 1][j] && matrice[i][j + 1] <= matrice[i][j])
	    matrice[i + 1][j + 1] = matrice[i][j + 1] + 1;
	  else if (matrice[i + 1][j] < matrice[i][j + 1] && matrice[i + 1][j] < matrice[i][j])
	    matrice[i + 1][j + 1] = matrice[i + 1][j] + 1;
	  else
	    matrice[i + 1][j + 1] = matrice[i][j] + 1;
	}
    }
  return matrice[i][j];
}
