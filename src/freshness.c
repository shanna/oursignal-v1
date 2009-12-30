#include "score.h"

int main (int arc, char* argv[]) {
  MYSQL_RES* links;
  MYSQL_ROW  link;
  int        updates = 0;

  os_init();
  score_init("freshness");
  printf("freshness ...\n");

  printf("select all links ... ");
  if (!(links = os_query("select url, ((now() - referred_at) / (60 * 60)) from links"))) return FALSE;
  printf("ok, %lu rows\n", (unsigned long int)mysql_num_rows(links));

  printf("updating scores  ... ");
  while ((link = mysql_fetch_row(links))) {
    float hours =  atof(link[1]);
    hours       =  hours < 24 ? ((24.0f - hours) / 24) : 0.0f;
    updates     += score_set(link[0], hours);
  }
  printf("ok, %d rows\n", updates);

  score_free();
  os_free();
  return TRUE;
}
