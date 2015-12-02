/*--------------------------------------------------------------------*/
/*		     Epitech EIP 2017 groupe Copypeste		      */
/*								      */
/*			    Algo Levenshtein			      */
/*								      */
/* @by :	Guillaume Krier					      */
/* @created :	19/09/2015					      */
/* @update :	19/09/201					      */
/*--------------------------------------------------------------------*/
#pragma once

/*\* INCLUDES *\*/
#include <stdlib.h>
#include "cp_types.h"

/*\* DEFINES *\*/
#define SIZE_RD_CHAR 512

/*\* PROTOTYPES *\*/
int16	compare_files_match(const char *path1, const char *path2, size_t size_rd);
