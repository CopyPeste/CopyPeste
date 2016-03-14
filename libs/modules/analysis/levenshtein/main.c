#include <stdio.h>
#include "levenshtein.h"

# define COMPARISON_NB 6
# define WORD_PER_COMPARISON 2
# define MAX_LENGTH 1062

static const char test_strings[COMPARISON_NB][WORD_PER_COMPARISON][MAX_LENGTH] = {
  // test empty strings
  { "", "" },
  { "", " " },
  { " ", "" },
  // same strings
  { "same strings", "same strings" },
  // differents strings
  { "different size", "different length" },
  // too long strings
  { "very long string", "Lorem ipsum dolor sit amet, consectetur adipiscing \
elit. Nullam pellentesque porta purus. Aenean lobortis nunc sed euismod \
tempor. Nam elementum vestibulum tellus suscipit finibus. Phasellus venenatis, \
tortor non sollicitudin condimentum, elit erat lacinia sem, sit amet blandit \
purus ipsum non elit. Donec ut nulla dignissim, ornare metus in, elementum \
erat. Proin id auctor purus. Quisque condimentum ex vitae lacinia ultrices. \
Vestibulum suscipit elementum velit quis molestie. Donec bibendum libero eu \
molestie dictum. Donec ac placerat velit. Proin at hendrerit sem, vel luctus \
massa. Phasellus luctus non elit et imperdiet. Aliquam ullamcorper urna magna, \
ut mattis odio tempor in. Morbi sit amet euismod est. Phasellus metus arcu, \
dignissim eget congue eleifend, ullamcorper vel dolor. Vestibulum dolor mi, \
vehicula ut egestas at, molestie rutrum augue. Phasellus fringilla orci id \
risus ullamcorper dapibus. Etiam sit amet nibh at felis imperdiet maximus quis \
nec quam. Cras tempus metus ipsum, quis rhoncus dui metus."}
};

static inline void testLevenshtein(const char *s1, const char *s2) {
  int distance = levenshtein(s1, s2);
  printf("Distance between \"%s\" and \"%s\": %d\n", s1, s2, distance);
  if (distance < 0)
    puts("strings are too big to be compared");
  else if (distance == 0)
    puts("strings are equal");
  else
    puts("strings are differents");
}

int main() {
  int i;
  for (i = 0; i < COMPARISON_NB; i++)
    testLevenshtein(test_strings[i][0], test_strings[i][1]);
}
