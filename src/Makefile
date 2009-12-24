# TODO: Redo with Scons, Automake or Mkmf?
CC     = cc
CFLAGS = $(shell mysql_config --cflags) -Wall -g

# If MySQL read/write speed doesn't remain the bottle neck OpenMP this sucker up? -fopenmp
LIBS = $(shell mysql_config --libs)

PROGRAMS = freshness frequency

all: $(PROGRAMS)

freshness:
	$(CC) $(CFLAGS) $(INCLUDES) -o freshness freshness.c $(LIBS)

frequency:
	$(CC) $(CFLAGS) $(INCLUDES) -o frequency frequency.c $(LIBS)

install:
	for program in $(PROGRAMS); do \
		install -m 0755 $$program ../bin; \
	done

clean:
	rm -f $(PROGRAMS) *.o *~
