
#pragma once

#include "file_handler.h"

/* PROTOTYPES */

/*
** Gets the percentage difference between two structure of line,
** compare word by word.
** Return the percentage difference between two strings,
** word by word algorithm.
**
** @param: line1 - structure of line one
** @param: line2 - structure of line two
** @return: Integer - return comparison value in percentage
*/
int	compare_words_strings(const s_line *string1, const s_line *string2);
