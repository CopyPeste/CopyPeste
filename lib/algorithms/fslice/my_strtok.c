 
#include <string.h>


static char *olds;

int	count_delim(char *s, const char *delim)
{
  int	count = 0;

  if (s == NULL)
    s = olds;

  /* Scan leading delimiters.  */
  count = strspn (s, delim);
  return count;
}

/* Parse S into tokens separated by characters in DELIM.
   If S is NULL, the last string strtok() was called with is
   used.  For example:
   char s[] = "-abc-=-def";
   x = strtok(s, "-");     // x = "abc"
   x = strtok(NULL, "-=");     // x = "def"
   x = strtok(NULL, "=");      // x = NULL
   // s = "abc\0=-def\0"
   */
char	*my_strtok(char *s, const char *delim)
{
  char *token;
  
  if (s == NULL)
    s = olds;
  
  /* Scan leading delimiters.  */
  s += strspn (s, delim);
  if (*s == '\0')
    {
      olds = s;
      return NULL;
    }
  
  /* Find the end of the token.  */
  token = s;
  s = strpbrk(token, delim);
  if (s == NULL)
    /* This token finishes the string.  */
    olds = strchr(token, '\0');
  else
    {
      /* Terminate the token and make OLDS point past it.  */
      *s = '\0';
      olds = s + 1;
    }
  return token;
}
