/*--------------------------------------------------------------------*/
/*		     Epitech EIP 2017 groupe Copypeste		      */
/*								      */
/*			    Algo Levenshtein			      */
/*								      */
/* @by :	Guillaume Krier					      */
/* @created :	19/09/2015					      */
/* @update :	19/09/201					      */
/*--------------------------------------------------------------------*/

/*\* INCLUDES *\*/
#include "compare.h"
#include "cp_md5.h"
#include <stdio.h>
/* open function */
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
/* read function */
#include <unistd.h>

#if defined(ONE_PER_ONE)
#include <string.h>
#endif /* ONE_PER_ONE */

/*\* STATIC FUNCTIONS *\*/
#if defined(ONE_PER_ONE)
/*
** int8 get_file_checksum(const char *path, char *sum, const size_t size_rd)
** @param: path - 
** @param: sum - 
** @param: size_rd - 
** @return: Integer - 
*/
static int8 get_file_checksum(const char *path, char *sum, const size_t size_rd)
{
  int16	fd;
  int32 len = 1;
  uchar	*buf;
  cp_md5_ctx ctx;
  
  if (!path || !(size_rd > 0))
    {
      CP_errno("PATH NULL\n");
      return ERROR_PARAM;
    }
  if ((buf = malloc(sizeof(char*) * (size_rd + 1))) == NULL)
    {
      CP_errno("malloc problem\n");
      return ERROR_SYSTEM;
    }
  if ((fd = open(path, O_RDONLY)) == -1) /* | O_BINARY */
    {
      CP_errno("open problem\n");
      return ERROR_SYSTEM;
    }

  cp_md5_init(&ctx);
  while (len > 0)
    {
      if ((len = read(fd, buf, size_rd)) < 0)
	return ERROR_SYSTEM;
      cp_md5_update(&ctx, buf, len);
    }
  cp_md5_final(&ctx, (uchar *)sum);
  free(buf);
  close(fd);
  return RET_SUCCESS;
}
#else
/*
** int8	get_files_compare_blocs(const char *path1, const char *path2, size_t size_rd)
** @param: path1 - 
** @param: path2 - 
** @param: size_rd - 
** @return: Integer - 
**
*/
static int8	get_files_compare_blocs(const char *path1, const char *path2, size_t size_rd)
{
  int16	fd1, fd2;
  uint32 len1, len2;
  uchar *buf1, *buf2;
  cp_md5_ctx ctx1, ctx2;

  if (!path1 || !path2 || !(size_rd > 0))
    {
      CP_errno("PATH NULL\n");
      return ERROR_PARAM;
    }
  if ((buf1 = malloc(sizeof(char*) * (size_rd + 1))) == NULL
      || (buf2 = malloc(sizeof(char*) * (size_rd + 1))) == NULL)
    {
      CP_errno("malloc problem\n");
      return ERROR_SYSTEM;
    }
  if ((fd1 = open(path1, O_RDONLY)) == -1 /* | O_BINARY */
      || (fd2 = open(path2, O_RDONLY)) == -1) /* | O_BINARY */
    {
      CP_errno("open problem\n");
      return ERROR_SYSTEM;
    }
  cp_md5_init(&ctx1);
  cp_md5_init(&ctx2);
  while ((len1 = read(fd1, buf1, size_rd)) > 0
	 && (len2 = read(fd2, buf2, size_rd)) > 0)
    {
      cp_md5_update(&ctx1, buf1, len1);
      cp_md5_update(&ctx2, buf2, len2);
      if (ctx1.A != ctx2.A
	  || ctx1.B != ctx2.B
	  || ctx1.C != ctx2.C
	  || ctx1.D != ctx2.D)
	return RET_FAILURE;
    }
  return RET_SUCCESS;
}
#endif /* ONE_PER_ONE */

#if defined(ONE_PER_ONE)
/* static void print_key(char *key) */
/* { */
/*   for (int j = 0; j < MAX_CP_MD_LEN; j++) */
/*     CP_message_arg("%02x", key[j]); */
/* } */
#endif /* ONE_PER_ONE */

/*\* FUNCTIONS *\*/

/*
** int compare_files_match(const char *path1, const char *path2)
** @param: path1 - The path of the first file.
** @param: path2 - The path of the second file.
** @return: Integer - Result of compare key files
**
** This function is use for compare two files whether
** the sum of her characteres are egal.
*/
int16	compare_files_match(const char *path1, const char *path2, size_t size_rd)
{
#if defined(ONE_PER_ONE)
  int ret;
  char sum1[MAX_CP_MD_LEN], sum2[MAX_CP_MD_LEN];
#endif /* ONE_PER_ONE */

  if (!path1 || !path2)
    {
      CP_errno("PATH NULL\n");
      return ERROR_PARAM;
    }
#if defined(ONE_PER_ONE)
  CP_message("Système de comparaison ficher par fichier\n");
  if ((ret = get_file_checksum(path1, sum1, size_rd)) < 0
      || (ret = get_file_checksum(path2, sum2, size_rd)) < 0)
    return ret;
  if (sum1[0] && sum2[0] && strncmp(sum1, sum2, MAX_CP_MD_LEN) == 0)
    {
      CP_message("Les fichiers sont identiques\n");
      return RET_SUCCESS;
    }
  CP_message("Les fichiers sont différents\n");
#else
  CP_message("Système de comparaison bloc par bloc\n");
  return get_files_compare_blocs(path1, path2, size_rd);
#endif /* ONE_PER_ONE */
  return RET_FAILURE;
}
