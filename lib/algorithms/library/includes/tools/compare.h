
#pragma once

#include "file_handler.h"

/* PROTOTYPES */

/*
** Gets the percentage of difference between two structures of line,
** compares word by word.
** Return the percentage of difference between two strings,
** word by word algorithm.
**
** @param: line1 - structure of line one
** @param: line2 - structure of line two
** @return: Integer - returns the comparison value in percentage
** or -1 in case of null strings
*/
int	compare_words_strings(const s_line *string1, const s_line *string2);

/*
** Gets the percentage of difference between two structures of line,
** compares word by word.
** Return the percentage of difference between two strings,
** word by word algorithm.
**
** @param: line1 - structure of line one
** @param: line2 - structure of line two
** @return: Integer - returns the comparison value in percentage
** or -1 in case of null strings
*/
int	compare_words_strings_inline(const s_line *line1, const s_line *line2);
