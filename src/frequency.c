#include "score.h"

#define FREQUENCY_SQL "select l.url, avg(f.daily_links) \
  from links l \
  join feed_links fl on (l.id = fl.link_id) \
  join feeds f on (f.id = fl.feed_id) \
  group by l.id"

#define BUCKET_SQL "select daily_links \
  from feeds \
  order by daily_links \
  desc limit 1"

typedef struct {
  int   value;
  float range;
} BUCKET;
BUCKET buckets[100];

bool bucket_init() {
  if (!db) {
    fprintf(stderr, "bucket_init: No db, did you remember to os_init()?\n");
    exit(FALSE);
  }

  MYSQL_RES* feeds;
  if (!(feeds = os_query("select count(*), max(daily_links) from feeds")))
    exit(FALSE);

  MYSQL_ROW feed = mysql_fetch_row(feeds);
  int   total    = atoi(feed[0]);
  float max      = atof(feed[1]);
  mysql_free_result(feeds);

  int i;
  int offset;
  char* bucket_offset_sql = malloc(strlen(BUCKET_SQL) + 11);
  for (i = 0; i < 100; i++) {
    buckets[i].value = i;

    offset = (int)(total * ((float)i / 100));
    sprintf(bucket_offset_sql, "%s offset %d", BUCKET_SQL, offset);

    if (!(feeds = os_query(bucket_offset_sql)))
      exit(FALSE);

    feed             = mysql_fetch_row(feeds);
    buckets[i].range = (feed) ? atof(feed[0]) : max;
    mysql_free_result(feeds);
  }
  free(bucket_offset_sql);
  return TRUE;
}

int bucket_score(float bv) {
  int i = 0;
  for (; i < 100; i++) {
    if (buckets[i].range < bv)
      return buckets[i].value;
  }
  return buckets[i-1].value;
}

int main (int arc, char* argv[]) {
  MYSQL_RES* links;
  MYSQL_ROW  link;
  int        updates = 0;

  os_init();
  score_init("frequency");
  bucket_init();
  printf("frequency ...\n");

  printf("select all links ... ");
  if (!(links = os_query(FREQUENCY_SQL))) return FALSE;
  printf("ok, %lu rows\n", (unsigned long int)mysql_num_rows(links));

  printf("updating scores  ... ");
  while ((link = mysql_fetch_row(links))) {
    float frequency =  1 - ((float)bucket_score(atof(link[1])) * 0.01f);
    updates         += score_set(link[0], frequency);
  }
  printf("ok, %d rows\n", updates);

  score_free();
  os_free();
  return TRUE;
}
