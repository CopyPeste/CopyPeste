#include <string.h>
#include "levenshtein.h"

/*
** Initialize the matrix
** @param: matrix, the matrix to initialize
*/
static
void	initialize(matrix_t matrix[MATRIX_SIZE][MATRIX_SIZE])
{
  int	i;

  matrix[0][0] = 0;
  for (i = 1; i < MATRIX_SIZE; i++)
  {
    matrix[0][i] = i;
    matrix[i][0] = i;
  }
}

/*
** Levenshtein algorithm - find the distance between two strings
** complexity: O(m * n) where m and n are the strings length
** @param: str1, first string to compare
** @param: str2, second string to compare
** @return: distance between str1 and str2, or -1 if a string is too long
*/
int			levenshtein(const char *str1, const char *str2)
{
  static matrix_t	matrix[MATRIX_SIZE][MATRIX_SIZE] = {{NOT_INITIALIZED}};
  size_t		i, j;
  size_t		s1 = strlen(str1);
  size_t		s2 = strlen(str2);

  // if a string is greater than MAX_MATRIX_SIZE, do not treat it
  if (s1 > MAX_WORD_SIZE || s2 > MAX_WORD_SIZE) return -1;

  // if a string is empty, we only have insertion to obtain the distance
  if (s1 == 0) return s2;
  if (s2 == 0) return s1;

  // check if matrix is initialized
  if (matrix[0][0] == NOT_INITIALIZED)
    initialize(matrix);

  // apply the algorithm on str1 and str2
  for (i = 0; i < s1; i++)
  {
    for (j = 0; j < s2; j++)
    {
      if (str1[i] == str2[j])
	matrix[i + 1][j + 1] = matrix[i][j];
      else if (matrix[i][j + 1] <= matrix[i + 1][j] && matrix[i][j + 1] <= matrix[i][j])
	matrix[i + 1][j + 1] = matrix[i][j + 1] + 1;
      else if (matrix[i + 1][j] < matrix[i][j + 1] && matrix[i + 1][j] < matrix[i][j])
	matrix[i + 1][j + 1] = matrix[i + 1][j] + 1;
      else
	matrix[i + 1][j + 1] = matrix[i][j] + 1;
    }
  }
  return matrix[i][j];
}
