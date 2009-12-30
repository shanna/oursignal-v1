# TODO: Redo with Scons, Automake or Mkmf?
CC     = cc
CFLAGS = $(shell mysql_config --cflags) -Wall -g

# If MySQL read/write speed doesn't remain the bottle neck OpenMP this sucker up? -fopenmp
LIBS = $(shell mysql_config --libs)

PROGRAMS = freshness frequency

all: $(PROGRAMS)

deps:
	$(CC) $(CFLAGS) $(INCLUDES) -c os.c $(LIBS)
	$(CC) $(CFLAGS) $(INCLUDES) -c score.c $(LIBS)

freshness: deps
	$(CC) $(CFLAGS) $(INCLUDES) os.o score.o freshness.c -o freshness $(LIBS)

frequency: deps
	$(CC) $(CFLAGS) $(INCLUDES) os.o score.o frequency.c -o frequency $(LIBS)

install:
	for program in $(PROGRAMS); do \
		install -m 0755 $$program ../bin; \
	done

clean:
	rm -f $(PROGRAMS) *.o *~
