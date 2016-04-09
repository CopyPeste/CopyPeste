
#pragma once

#include "file_handler.h"

/* PROTOTYPES */

/*
** Gets the percentage difference between two files,
** word by word.
** Return the percentage difference between two strings,
** word by word algorithm.
**
** @param: str_file1 - string representing the first file
** @param: str_file2 - string representing the second file
** @return: Integer - return comparison value in percentage
*/
int	compare_words_strings(const s_line *string1, const s_line *string2);
