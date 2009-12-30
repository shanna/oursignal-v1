#ifndef SCORE_H
#define SCORE_H

#include "os.h"

#define SCORE_SQL "insert into \
  scores (id, source, url, score, created_at, updated_at) \
  values (sha1(?), ?, ?, ?, now(), now()) \
  on duplicate key update score = ?, updated_at = now()"

MYSQL_STMT*   score_sth;
MYSQL_BIND    score_binds[5];
char*         score_id;
char*         score_source;
unsigned long score_id_length;
unsigned long score_url_length;
unsigned long score_source_length;

bool score_init(char*);
void score_free();
int  score_set(char*, float);

#endif
