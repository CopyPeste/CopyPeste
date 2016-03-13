/*
 * FDUPES Copyright (c) 1999 Adrian Lopez
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * Github : https://github.com/adrianlopezroche/fdupes.git
 * =======================================================
 *
 * This algorithm is taken from the real fdupes programme
 * and has been modified for the CopyPeste project.
 *
*/


#include "fdupes_algo.h"


/*
 * Compares the content of the two file
 *
 * @param [char *] content of the first file
 * @param [char *] content of the second file
 * @param [int] size of the content for the first file
 * @param [int] size of the content for the second file
 * @Retrun [int] return 0 if file content matched else return -1
 */
static int	confirmmatch(char *file1, char *file2, int size1, int size2)
{
  if (size1 != size2)
    return -1;
  if (memcmp (file1, file2, size1))
    return -1;
  return 0;
}


/*
 * Compares the two md5 signature of the two file to analyse
 *
 * @param [const md5_byte_t *] md5 signature of the first file
 * @param [const md5_byte_t *] md5 signature of the second file
 * @Return [int] return 0 if md5 signature matched else reture -1/1
 */
static int	md5cmp(const md5_byte_t *a, const md5_byte_t *b)
{
  int		x;

  for (x = 0; x < MD5_DIGEST_LENGTH; ++x)
  {
    if (a[x] < b[x])
      return -1;
    if (a[x] > b[x])
      return 1;
  }
  return 0;
}


/*
 * This function copy the md5 signature from a static to a non-static variable
 *
 * @param [md5_byte_t *] md5 pointer that will get the md5 signature
 * @param [const md5_byte_t *] locacl variable that contain the signature
 */
static void	md5copy(md5_byte_t *to, const md5_byte_t *from)
{
  int		x;

  for (x = 0; x < MD5_DIGEST_LENGTH; ++x)
    to[x] = from[x];
}


/*
 * This function return the partial or full signature off a file
 *
 * @param [char *] content of a file
 * @param [off_t] PARTIAL_MD5_SIZE for partial signature or 0 for full signature
 * @param [off_t] size of the content file
 * @Return [md5_byte_t] return the full or partial signature of the file]
 */
static md5_byte_t	*getcrcsignatureuntil(char *file, off_t max_read, off_t fsize)
{
  off_t		toread;
  md5_state_t	state;
  static md5_byte_t digest[MD5_DIGEST_LENGTH];
  static md5_byte_t chunk[CHUNK_SIZE];
  static char	*tmp;

  md5_init(&state);
  tmp = file;
  if (max_read != 0 && fsize > max_read)
    fsize = max_read;
  while (fsize > 0) {
    toread = (fsize >= CHUNK_SIZE) ? CHUNK_SIZE : fsize;
    memcpy(chunk, file, toread);
    file = &(file[toread]);
    md5_append(&state, chunk, toread);
    fsize = fsize - toread;
  }
  file = &(tmp[0]);
  md5_finish(&state, digest);
  return digest;
}


/*
 * This function get the all signature of a file
 *
 * @param [char *] content of the file
 * @param [off_t] size of the content file
 * @Return [md5_byte_t] return the full signature of the file
 */
static inline md5_byte_t	*getcrcsignature(char *file, off_t fsize)
{
  return getcrcsignatureuntil(file, 0, fsize);
}


/*
 * This function get the partial signature of a file PARTIAL_MD5_SIZE = 4096
 *
 * @param [char *] content of the file
 * @param [off_t] size of the content file
 * @Return [md5_byte_t] return the partial signature of the file
 */
static inline md5_byte_t	*getcrcpartialsignature(char *file, off_t fsize)
{
  return getcrcsignatureuntil(file, PARTIAL_MD5_SIZE, fsize);
}


/*
 * This function is the main of the fdupes algorithm.
 * It takes the content and the size of two file to analyses
 *
 * @param [char *] Content of a file
 * @param [int] size of this file content
 * @param [char *] content of a file
 * @param [int] size of this file content
 * @Return [int] return 0 if file matched else return -1/1
 */
int		fdupes_match(char *file1, int size1, char *file2, int size2)
{
  int		cmpresult;
  md5_byte_t	*tmp;
  md5_byte_t	*crcsignature1;
  md5_byte_t	*crcsignature2;

  tmp = getcrcpartialsignature(file1, (off_t)size1);
  crcsignature1 = (md5_byte_t*) malloc(MD5_DIGEST_LENGTH * sizeof(md5_byte_t));
  if (crcsignature1 == NULL) {
    fprintf(stderr, "out of memory\n");
    exit(1);
  }
  md5copy(crcsignature1, tmp);

  tmp = getcrcpartialsignature(file2, (off_t)size2);
  crcsignature2 = (md5_byte_t*) malloc(MD5_DIGEST_LENGTH * sizeof(md5_byte_t));
  if (crcsignature1 == NULL) {
    fprintf(stderr, "out of memory\n");
    exit(1);
  }
  md5copy(crcsignature2, tmp);

  cmpresult = md5cmp(crcsignature1, crcsignature2);
  free(crcsignature1);
  free(crcsignature2);

  if (cmpresult == 0)
    {
      tmp = getcrcsignature(file1, (off_t)size1);
      crcsignature1 = (md5_byte_t*) malloc(MD5_DIGEST_LENGTH * sizeof(md5_byte_t));
      if (crcsignature1 == NULL) {
	fprintf(stderr, "out of memory\n");
	exit(1);
      }
      md5copy(crcsignature1, tmp);

      tmp = getcrcsignature(file2, (off_t)size2);
      crcsignature2 = (md5_byte_t*) malloc(MD5_DIGEST_LENGTH * sizeof(md5_byte_t));
      if (crcsignature1 == NULL) {
	fprintf(stderr, "out of memory\n");
	exit(1);
      }
      md5copy(crcsignature2, tmp);

      cmpresult = md5cmp(crcsignature1, crcsignature2);
      free(crcsignature1);
      free(crcsignature2);
    }
  if (cmpresult == 0)
    return confirmmatch(file1, file2, size1, size2);
  return cmpresult;
}
