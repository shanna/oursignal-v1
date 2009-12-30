#include "score.h"

bool score_init(char* source) {
  score_source        = source;
  score_source_length = strlen(source);

  if (!db) {
    fprintf(stderr, "score_init: No db, did you remember to os_init()?\n");
    exit(FALSE);
  }
  score_sth = mysql_stmt_init(db);
  if (mysql_stmt_prepare(score_sth, SCORE_SQL, strlen(SCORE_SQL))) {
    fprintf(stderr, "score_init: %s\n", mysql_stmt_error(score_sth));
    exit(FALSE);
  }

  memset(score_binds, 0, sizeof(score_binds));
  score_id = malloc(305); // source 50 + url 255

  score_binds[0].buffer_type   = MYSQL_TYPE_STRING;
  score_binds[0].buffer_length = 300;
  score_binds[1].buffer_type   = MYSQL_TYPE_STRING;
  score_binds[1].buffer_length = 50;
  score_binds[1].buffer        = score_source;
  score_binds[1].length        = &score_source_length;
  score_binds[2].buffer_type   = MYSQL_TYPE_STRING;
  score_binds[2].buffer_length = 255;
  score_binds[3].buffer_type   = MYSQL_TYPE_FLOAT;
  score_binds[4].buffer_type   = MYSQL_TYPE_FLOAT;

  return TRUE;
}


int score_set(char* url, float score) {
  strcpy(score_id, score_source);
  strcat(score_id, url);

  score_id_length = strlen(score_id);
  score_binds[0].buffer = score_id;
  score_binds[0].length = &score_id_length;

  score_url_length = strlen(url);
  score_binds[2].buffer  = url;
  score_binds[2].length  = &score_url_length;

  score_binds[3].buffer  = (char*)&score;
  score_binds[3].length  = 0;
  score_binds[3].is_null = 0;

  score_binds[4].buffer  = (char*)&score;
  score_binds[4].length  = 0;
  score_binds[4].is_null = 0;

  if (mysql_stmt_bind_param(score_sth, score_binds)) {
    fprintf(stderr, "%s\n", mysql_stmt_error(score_sth));
    return 0;
  }

  if (mysql_stmt_execute(score_sth)) {
    fprintf(stderr, "%s\n", mysql_stmt_error(score_sth));
    return 0;
  }

  // Silly MySQL returns 2 on duplicate keys. It's 'rows' affected dickheads, not successful statments.
  return (mysql_stmt_affected_rows(score_sth) > 0) ? 1 : 0;
}

void score_free() {
  if (score_id)  free(score_id);
  if (score_sth) mysql_stmt_close(score_sth);
}
