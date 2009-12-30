#ifndef OS_H
#define OS_H

#include <mysql.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef int bool;
#define FALSE 0
#define TRUE (-1)

MYSQL*     db;
bool       os_init();
void       os_free();
MYSQL_RES* os_query(char*);

#endif
