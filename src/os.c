#include "os.h"

/*
 * TODO: Yick, hard coded credentials but I'm in a rush.
 */
bool os_init() {
  db = mysql_init(NULL);
  if (!mysql_real_connect(db, "127.0.0.1", "root", "", "oursignal", 3306, NULL, 0)) {
    fprintf(stderr, "mysql connection error: %s\n", mysql_error(db));
    return FALSE;
  }
  return TRUE;
}

/*
 * TODO: Whats the convention here? Should the signature be bool db_query(MYSQL_RES*, char* sql) since I'm expecting
 * you to free that result?
 */
MYSQL_RES* os_query(char* sql) {
  if (mysql_query(db, sql)) {
    fprintf(stderr, "mysql query error: %s\n", mysql_error(db));
    return NULL;
  }

  MYSQL_RES* sth;
  if (!(sth = mysql_store_result(db))) {
    fprintf(stderr, "mysql query error: %s\n", mysql_error(db));
    return NULL;
  }
  return sth;
}

void os_free() {
  if (db) mysql_close(db);
}
