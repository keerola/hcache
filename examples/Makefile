CC = ../bin/hcache gcc
LD = gcc

INCDIRS = -Iinclude

OBJS = test1.o
PROG = test1

all: $(PROG)

clean:
	rm -f $(OBJS) $(PROG)

$(PROG): $(OBJS)
	$(LD) $(LDFLAGS) -o $(PROG) $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) $(INCDIRS) -c -o $@ $<

.PHONY: all clean

