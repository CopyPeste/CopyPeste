

#include <sys/stat.h>
#include <md5/md5.h>


#define CHUNK_SIZE 8192

#define INPUT_SIZE 256

#define PARTIAL_MD5_SIZE 4096

#define MD5_DIGEST_LENGTH 16



typedef struct _file {
  char *d_name;
  off_t size;
  md5_byte_t *crcpartial;
  md5_byte_t *crcsignature;
  dev_t device;
  ino_t inode;
  time_t mtime;
  int hasdupes; /* true only if file is first on duplicate chain */
  struct _file *duplicates;
  struct _file *next;
} file_t;


void errormsg(char *message, ...)
{
  va_list ap;

  va_start(ap, message);

  fprintf(stderr, "\r%40s\r%s: ", "", program_name);
  vfprintf(stderr, message, ap);
}


/* Do a bit-for-bit comparison in case two different files produce the 
   same signature. Unlikely, but better safe than sorry. */
/*
int		confirmmatch(FILE *file1, FILE *file2)
{
  unsigned char c1[CHUNK_SIZE];
  unsigned char c2[CHUNK_SIZE];
  size_t r1;
  size_t r2;
  
  fseek(file1, 0, SEEK_SET);
  fseek(file2, 0, SEEK_SET);

  do {
    r1 = fread(c1, sizeof(unsigned char), sizeof(c1), file1);
    r2 = fread(c2, sizeof(unsigned char), sizeof(c2), file2);

    if (r1 != r2) return 0; /* file lengths are different 
    if (memcmp (c1, c2, r1)) return 0; /* file contents are different
  } while (r2);
  
  return 1;
}
*/


/*
md5_byte_t	*getcrcsignature(char *filename)
{
  return getcrcsignatureuntil(filename, 0);
}

md5_byte_t	*getcrcpartialsignature(char *filename)
{
  return getcrcsignatureuntil(filename, PARTIAL_MD5_SIZE);
}

int		md5cmp(const md5_byte_t *a, const md5_byte_t *b)
{
  int x;

  for (x = 0; x < MD5_DIGEST_LENGTH; ++x)
  {
    if (a[x] < b[x])
      return -1;
    else if (a[x] > b[x])
      return 1;
  }

  return 0;
}

void		md5copy(md5_byte_t *to, const md5_byte_t *from)
{
  int x;

  for (x = 0; x < MD5_DIGEST_LENGTH; ++x)
    to[x] = from[x];
}


int		is_hardlink(filetree_t *checktree, file_t *file)
{
  file_t *dupe;
  ino_t inode;
  dev_t device;

  inode = getinode(file->d_name);
  device = getdevice(file->d_name);

  if ((inode == checktree->file->inode) && 
      (device == checktree->file->device))
        return 1;

  if (checktree->file->hasdupes)
  {
    dupe = checktree->file->duplicates;

    do {
      if ((inode == dupe->inode) &&
          (device == dupe->device))
            return 1;

      dupe = dupe->duplicates;
    } while (dupe != NULL);
  }

  return 0;
}
*/

off_t file_size(char *filename)
{
  struct stat s;

  if (stat(filename, &s) != 0) return -1;

  return s.st_size;
}

dev_t get_device(char *filename)
{
  struct stat s;

  if (stat(filename, &s) != 0) return 0;

  return s.st_dev;
}

ino_t get_inode(char *filename)
{
  struct stat s;
   
  if (stat(filename, &s) != 0) return 0;

  return s.st_ino;   
}

time_t get_mtime(char *filename)
{
  struct stat s;

  if (stat(filename, &s) != 0) return 0;

  return s.st_mtime;
}

void get_file_stats(file_t *file)
{
  file->size = file_size(file->d_name);
  file->inode = get_inode(file->d_name);
  file->device = get_device(file->d_name);
  file->mtime = get_mtime(file->d_name);
}

void		init_struct(file_t *new_file)
{
  new_file->device = 0;
  new_file->inode = 0;
  new_file->crcsignature = NULL;
  new_file->crcpartial = NULL;
  new_file->duplicates = NULL;
  new_file->hasdupes = 0;
  get_file_stats(new_file);
}

bool		checkmatch(char *file1, char *file2)
{
  int cmpresult;
  md5_byte_t *crcsignature;
  off_t fsize;
  file_t file_1;
  file_t file_2;
  
  file_1 = (file_t) malloc(sizeof(file_t));
  file_2 = (file_t) malloc(sizeof(file_t));
  if (file_1 == NULL || file_2 == NULL)
    errormsg ("Error cannot allocate memory\n");
  
  file_1.d_name = (char*)malloc(strlen(file1)+2);
  file_2.d_name = (char*)malloc(strlen(file2)+2);
  
  strcat(file_1.d_name, file1);
  strcat(file_2.d_name, file2);

  init_struct(&file_1);
  init_struct(&file_2);
  
    //if is_hardlink(checktree, file)
    //return false;
  /*
  fsize = filesize(file->d_name);
  
  if (fsize < checktree->file->size) //size file2 < file1
    cmpresult = -1;
  else 
    if (fsize > checktree->file->size) 
      cmpresult = 1;
    else
      if (ISFLAG(flags, F_PERMISSIONS) &&
	  !same_permissions(file->d_name, checktree->file->d_name))
        cmpresult = -1;
      else {
	if (checktree->file->crcpartial == NULL) {
	  crcsignature = getcrcpartialsignature(checktree->file->d_name);

	  if (crcsignature == NULL) {
	    errormsg ("cannot read file %s\n", checktree->file->d_name);
	    return NULL;
	  }

	  checktree->file->crcpartial = (md5_byte_t*) malloc(MD5_DIGEST_LENGTH * sizeof(md5_byte_t));

	  if (checktree->file->crcpartial == NULL) {
	    errormsg("out of memory\n");
	    exit(1);
	  }

	  md5copy(checktree->file->crcpartial, crcsignature);
	}

	if (file->crcpartial == NULL) {

	  crcsignature = getcrcpartialsignature(file->d_name);

	  if (crcsignature == NULL) {
	    errormsg ("cannot read file %s\n", file->d_name);
	    return NULL;
	  }

	  file->crcpartial = (md5_byte_t*) malloc(MD5_DIGEST_LENGTH * sizeof(md5_byte_t));

	  if (file->crcpartial == NULL) {
	    errormsg("out of memory\n");
	    exit(1);
	  }

	  md5copy(file->crcpartial, crcsignature);
	}

	cmpresult = md5cmp(file->crcpartial, checktree->file->crcpartial);

	if (cmpresult == 0) {
	  if (checktree->file->crcsignature == NULL) {
	    crcsignature = getcrcsignature(checktree->file->d_name);
	    if (crcsignature == NULL) return NULL;

	    checktree->file->crcsignature = (md5_byte_t*) malloc(MD5_DIGEST_LENGTH * sizeof(md5_byte_t));
	    if (checktree->file->crcsignature == NULL) {
	      errormsg("out of memory\n");
	      exit(1);
	    }
	    md5copy(checktree->file->crcsignature, crcsignature);
	  }

	  if (file->crcsignature == NULL) {
	    crcsignature = getcrcsignature(file->d_name);
	    if (crcsignature == NULL) return NULL;

	    file->crcsignature = (md5_byte_t*) malloc(MD5_DIGEST_LENGTH * sizeof(md5_byte_t));
	    if (file->crcsignature == NULL) {
	      errormsg("out of memory\n");
	      exit(1);
	    }
	    md5copy(file->crcsignature, crcsignature);
	  }

	  cmpresult = md5cmp(file->crcsignature, checktree->file->crcsignature);
	}
      }

  if (cmpresult < 0) {
    if (checktree->left != NULL) {
      return checkmatch(root, checktree->left, file);
    } else {
      registerfile(&(checktree->left), file);
      return NULL;
    }
  } else if (cmpresult > 0) {
    if (checktree->right != NULL) {
      return checkmatch(root, checktree->right, file);
    } else {
      registerfile(&(checktree->right), file);
      return NULL;
    }
  } else 
    {
      getfilestats(file);
      return &checktree->file;
      }*/
}
