
#ifndef LEVENSHTEIN_H_
# define LEVENSHTEIN_H_

#include "main.h"
#include <string.h>

void    initMatrice(char **file, int **matrice);
void    initLevenshtein(char **file);
void	freeMatrice(int **matrice);
void	emptyMatrice(int **matrice);
void	startLevenshtein(int **matrice, int firstWord, int secondWord);
void	fillBySecond(char **file, int **matrice, int firstWord, int secondWord, int i);
void	fillByFirst(char **file, int **matrice, int firstWord, int secondWord, int i);

#endif /* LEVENSHTEIN_H_ */
