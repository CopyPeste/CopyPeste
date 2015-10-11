/*--------------------------------------------------------------------*/
/*		     Epitech EIP 2017 groupe Copypeste		      */
/*								      */
/*			    Algo Levenshtein			      */
/* developed by :						      */
/* Edouard Marechal						      */
/* Amina Ourouba						      */
/*--------------------------------------------------------------------*/

#include "levenshtein.h"

/******Fonction pour les test, affiche la matrice de l'algo*******/

void	printToSee(int **matrice) {

  int save = 0;
  int i = 0;
  int j = 0;

  for (i = 0; matrice[i][0] > -1; i++) {
    for (j = 0; matrice[i][j] > -1; j++) {
      if (matrice[i][j] < 10)
	printf("  %d  |", matrice[i][j]);
      else if (matrice[i][j] < 100)
	printf("  %d |", matrice[i][j]);
      else
      printf(" %d |", matrice[i][j]);
    }
    printf("\n");
  }
  printf("======> %d \n ", matrice[i-1][j-1]);
}

/*****************************************************************/

void	freeMatrice(int **matrice) {
 
  /*  for (int i = 0; matrice[i][0] > -1; i++) {
    free(matrice[i]);
  }
  free(matrice);*/
}

void	emptyMatrice(int **matrice) {
  
  for (int i = 0; matrice[i][0] > -1; i++) {
    for (int j = 0; matrice[i][j] > -1; j++) {
      matrice[i][j] = -1;
    }
  }
}

void	startLevenshtein(int **matrice, int firstWord, int secondWord) {

  int i = 2;
  int j = 2;

  while (i < secondWord+2) {
    while (j < firstWord+2) 
      {
	if (matrice[i][0] == matrice[0][j])
	  matrice[i][j] = matrice[i-1][j-1];
	else if (matrice[i-1][j] <= matrice[i][j-1] &&
		 matrice[i-1][j] <= matrice[i-1][j-1])
	  matrice[i][j] = matrice[i-1][j] + 1;
	else if (matrice[i][j-1] < matrice[i-1][j] &&
		 matrice[i][j-1] < matrice[i-1][j-1])
	  matrice[i][j] = matrice[i][j-1] + 1;
	else
	  matrice[i][j] = matrice[i-1][j-1] + 1;
	j++;
      }
    matrice[i][j] = -1;
    i++;
    j = 2;
  }
  matrice[i][0] = -1;
  printToSee(matrice);
}

void	fillBySecond(char **file, int **matrice, int firstWord, int secondWord, int i) {

  int index = 0;

    for (index = 0; index < secondWord; index++) {
      if (index < firstWord) {
	matrice[0][index+2] = file[i][index];
	matrice[1][index+2] = index+1;
      }
      else {
	matrice[0][index+2] = -1;
	matrice[1][index+2] = -1;
      }
      matrice[index+2][0] = file[i+1][index];
      matrice[index+2][1] = index+1;
    }
    startLevenshtein(matrice, firstWord, secondWord);
}

void	fillByFirst(char **file, int **matrice, int firstWord, int secondWord, int i) {

  int index = 0;

    for (index = 0; index < firstWord; index++) {
      matrice[0][index+2] = file[i][index];
      matrice[1][index+2] = index+1;
      if (index < secondWord) {
	matrice[index+2][0] = file[i+1][index];
	matrice[index+2][1] = index+1;
      }
    }
    matrice[0][firstWord+2] = -1;
    matrice[1][firstWord+2] = -1;
    startLevenshtein(matrice, firstWord, secondWord);
}

void	initMatrice(char **file, int **matrice) {

  int firstWord;
  int secondWord;
  int i = 0;

  while (file[i] != NULL) {
    matrice[0][0] = 0;
    matrice[0][1] = 0;
    matrice[1][0] = 0;
    matrice[1][1] = 0;
    firstWord = strlen(file[i]);
    secondWord = strlen(file[i+1]);
    if (firstWord >= secondWord)
      fillByFirst(file, matrice, firstWord, secondWord, i);
    else
      fillBySecond(file, matrice, firstWord, secondWord, i);
    emptyMatrice(matrice);
    i += 2;
  }
  freeMatrice(matrice);
}

void	initLevenshtein(char **file) {

  int **matrice;

  matrice = malloc(sizeof(int) * 1042);
  for (int i = 0; i < sizeof(int) * 1042; i++) {
    matrice[i] = malloc(sizeof(int) * 1042);
  }
  initMatrice(file, matrice);
}
