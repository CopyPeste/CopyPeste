#include <stdlib.h>
#include <string.h>
#include "levenshtein.h"

/*
** return the longest size between two integers
** @param: str1, first integer to compare
** @param: str2, second integer to compare
** @return: the longest size
*/
static inline size_t longest_between(size_t s1, size_t s2)
{
  return s1 > s2 ? s1 : s2;
}

/*
** Initialize the matrix values
** @param: matrix, the matrix to initialize
** @param: size, matrix size (the matrix has as many rows as columns)
** @return: the initialized matrix
*/
static matrix_t	*initialize_values(matrix_t *matrix, size_t size)
{
  size_t	i;

  matrix[0] = 0;
  for (i = 1; i < size; i++)
  {
    matrix[i] = i;
    matrix[size * i] = i;
  }
  return matrix;
}

/*
** Levenshtein algorithm - find the distance between two strings
** @param: str1, first string to compare
** @param: str2, second string to compare
** @return: the distance between the two strings, or -1 if malloc fail
*/
int			levenshtein(const char *str1, const char *str2)
{
  matrix_t		*matrix = NULL;
  uint16_t		i, j;
  size_t		s1 = strlen(str1);
  size_t		s2 = strlen(str2);
  size_t		size = longest_between(s1, s2);
  matrix_t		*m_i, *m_ip1;

  // if a string is empty, we only have insertion to obtain the distance
  if (s1 == 0) return s2;
  if (s2 == 0) return s1;

  // initialize the matrix
  matrix = malloc(sizeof matrix * size * size);
  if (matrix == NULL)
    return -1;
  initialize_values(matrix, size);
  // apply the algorithm on str1 and str2
  for (i = 0; str1[i]; i++)
  {
    m_i = matrix + i * size;
    m_ip1 = matrix + ((i + 1) * size);
    for (j = 0; str2[j]; j++)
    {
      if (str1[i] == str2[j])
	m_ip1[j + 1] = m_i[j];
      else if (m_i[j + 1] <= m_ip1[j] && m_i[j + 1] <= m_i[j])
	m_ip1[j + 1] = m_i[j + 1] + 1;
      else if (m_ip1[j] < m_i[j + 1] && m_ip1[j] < m_i[j])
	m_ip1[j + 1] = m_ip1[j] + 1;
      else
	m_ip1[j + 1] = m_i[j] + 1;
    }
  }
  uint16_t v = matrix[i * size + j];
  free(matrix);
  return v;
}
