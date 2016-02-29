#include <stdio.h>
#include "levenshtein.h"

int main() {
  printf("'' '' = %d\n", levenshtein("", ""));
  printf("'' ' ' = %d\n", levenshtein("", " "));
  printf("' ' '' = %d\n", levenshtein(" ", ""));
  printf("a  b  = %d\n", levenshtein("a", "b"));
  printf("azertyuiop azertyuiop = %d\n", levenshtein("azertyuiop", "azertyuiop"));
  printf("aerferf  aferferf =  %d\n", levenshtein("aerferf", "aferferf"));
  printf("aer864fe6r8f4e6r  erferffera = %d\n", levenshtein("aer864fe6r8f4e6r", "erferffera"));
  printf("aferf  azefozeifoeriehifuher  = %d\n", levenshtein("aferf", "azefozeifoeriehifuher"));
}
