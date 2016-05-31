#ifndef	LEVENSHTEIN_H_
# define LEVENSHTEIN_H_

# include <stdint.h>

// strings max size
# define MAX_WORD_SIZE 1024

# define NOT_INITIALIZED 1

/*
** matrix size, equal to string max size, +1 because 1 line and 1 column
** are reserved for matrix informations
*/
# define MATRIX_SIZE (MAX_WORD_SIZE + 1)

typedef uint16_t matrix_t;

int	levenshtein(const char *str1, const char *str2);

#endif /* LEVENSHTEIN_H_ */
