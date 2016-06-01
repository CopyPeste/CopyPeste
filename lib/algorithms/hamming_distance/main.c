#include <stdio.h>

#include "hamming_distance.h"

#define COMPARISON_NB 5
#define WORD_PER_COMPARISON 2
#define MAX_LENGTH 18

static const char test_strings[COMPARISON_NB][WORD_PER_COMPARISON][MAX_LENGTH] = {
  // test empty strings
  { "", "" },
  { "", " " },
  { " ", "" },
  // same strings
  { "same strings", "same strings" },
  // differents strings
  { "different strings", "abcdefghi strings" }
};

static inline
void testHamming(const char *str1, const char *str2) {
  printf("Distance between \"%s\" and \"%s\": %d\n", str1, str2, hamming_distance(str1, str2));
}

int	main() {
  int i;
  for (i = 0; i < COMPARISON_NB; i++)
    testHamming(test_strings[i][0], test_strings[i][1]);
}
