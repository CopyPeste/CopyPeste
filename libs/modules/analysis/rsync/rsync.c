
/* INCLUDES */
#include "rsync.h"

#include <string.h>

#include <openssl/md5.h>

/* DEFINES */
#define MAX_MD5_LEN MD5_DIGEST_LENGTH

/*
** Returns the result between
** two file with hash MD5 blocks.
**
** @param: str_file1 - string representing the first file
** @param: str_file2 - string representing the second file
** @param: size_rd - size to read in the strings
** @return: Integer - return the comparison result
*/
static int	compare_blocks(char *str_file1, char *str_file2, size_t size_rd)
{
  unsigned int	len1, len2;
  unsigned int	cpt1 = 0, cpt2 = 0;
  MD5_CTX	ctx1, ctx2;

  MD5_Init(&ctx1);
  MD5_Init(&ctx2);

  len1 = strlen(str_file1);
  len2 = strlen(str_file2);

  while (len1 > cpt1 || len2 > cpt2)
    {
      MD5_Update(&ctx1, str_file1 + cpt1, ((cpt1 + size_rd) > len1 ? len1 - cpt1: size_rd));
      MD5_Update(&ctx2, str_file2 + cpt2, ((cpt2 + size_rd) > len2 ? len2 - cpt2: size_rd));
      if (memcmp(&ctx1.data[0], &ctx2.data[0], MAX_MD5_LEN) != 0
	  || memcmp(&ctx1.data[1], &ctx2.data[1], MAX_MD5_LEN) != 0
	  || memcmp(&ctx1.data[2], &ctx2.data[2], MAX_MD5_LEN) != 0
	  || memcmp(&ctx1.data[3], &ctx2.data[3], MAX_MD5_LEN) != 0)
	return -1;
      cpt1 += size_rd;
      cpt2 += size_rd;
    }
  return 0;
}

/*
** Compares two files and finds
** if the sum of their characters are equal.
**
** @param: path1 - string representing the first file
** @param: path2 - string representing the second file
** @return: Integer - return the result of Diff compared
*/
int	rsync(char *str_file1, char *str_file2, size_t size_rd)
{
  int	ret;

  if (!str_file1 || !str_file2 || !(size_rd > 0))
    return -1;
  if (strlen(str_file1) != strlen(str_file2))
    return -1;
  ret = compare_blocks(str_file1, str_file2, size_rd);
  return ret;
}

/*
** Returns the result between two files in bytes.
**
** @param: str_file1 - string representing the first file
** @param: str_file2 - string representing the second file
** @return: Integer - return the result of char compared
*/
static int comfirm_checksum(char *str_file1, char *str_file2)
{
  char *tmp_file1, *tmp_file2;

  tmp_file1 = str_file1;
  tmp_file2 = str_file2;

  while (*tmp_file1 && *tmp_file2)
    {
      if (*tmp_file1 != *tmp_file2)
	return -1;
      ++tmp_file1;
      ++tmp_file2;
    }
  return 0;
}

/*
** This function returns the result between
** two file with a hash MD5 blocks.
**
** @param: str_file1 - string representing the first file
** @param: str_file2 - string representing the second file
** @param: size_rd - size to read in the strings
** @return: Integer - return the result of Checksum compared
*/
static int	compare_checksums(char *str_file1, char *str_file2, size_t size_rd)
{
  unsigned int	len1, len2;
  unsigned int	cpt1 = 0, cpt2 = 0;
  MD5_CTX	ctx1, ctx2;
  unsigned char	digest1[MAX_MD5_LEN], digest2[MAX_MD5_LEN];

  MD5_Init(&ctx1);
  MD5_Init(&ctx2);

  len1 = strlen(str_file1);
  len2 = strlen(str_file2);

  while (len1 > cpt1 && len2 > cpt2)
    {
      MD5_Update(&ctx1, str_file1 + cpt1, size_rd);
      MD5_Update(&ctx2, str_file1 + cpt2, size_rd);
      cpt1 += size_rd;
      cpt2 += size_rd;
    }
  MD5_Final(digest1, &ctx1);
  MD5_Final(digest2, &ctx2);
  if (memcmp(digest1, digest2, MAX_MD5_LEN) == 0)
    return comfirm_checksum(str_file1, str_file2);
  return -1;
}

/*
** Compares two files and finds
** if the checksum of their characters are equal.
**
** @param: path1 - string representing the first file
** @param: path2 - string representing the second file
** @return: Integer - return the result of Diff compared
*/
int	rsync_checksum(char *str_file1, char *str_file2, size_t size_rd)
{
  int	ret;

  if (!str_file1 || !str_file2 || !(size_rd > 0))
    return -1;
  if (strlen(str_file1) != strlen(str_file2))
    return -1;
  ret = compare_checksums(str_file1, str_file2, size_rd);
  return ret;
}
