/*--------------------------------------------------------------------*/
/*		     Epitech EIP 2017 groupe Copypeste		      */
/*								      */
/*			    Algo Rsync				      */
/*								      */
/* @by :	Guillaume Krier					      */
/* @created :	19/09/2015					      */
/* @update :	29/02/2015					      */
/*--------------------------------------------------------------------*/
#pragma once

#include <stdlib.h>

/* DEFINES */
#define SIZE_RD_CHAR 512

/* PROTOTYPES */

/*
** This function is used to compare two files and find
** whether the sum of its characters are equal.
**
** @param: path1 - The string of the first file.
** @param: path2 - The string of the second file.
** @return: Integer - Its return the result of Diff compared.
*/
int	rsync(char *str_file1, char *str_file2, size_t size_rd);

/*
** This function is used to compare two files and find
** whether the checksum of its characters are equal.
**
** @param: path1 - The string of the first file.
** @param: path2 - The string of the second file.
** @return: Integer - Its return the result of Diff compared.
*/
int	rsync_checksum(char *str_file1, char *str_file2, size_t size_rd);
