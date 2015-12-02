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
#include "copypeste.h"

#include <openssl/md5.h>

/*\* TYPEDEF *\*/
typedef MD5_CTX cp_md5_ctx;

/*\* DEFINES *\*/
#define MAX_CP_MD_LEN 16

/*\* PROTOTYPES *\*/
void cp_md5_init(cp_md5_ctx *ctx);
void cp_md5_update(cp_md5_ctx *ctx, const uchar *input, uint32 length);
void cp_md5_final(cp_md5_ctx *ctx, uchar *digest);
