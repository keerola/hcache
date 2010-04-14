CC = ../bin/hcache --relative gcc
LD = gcc

INCDIRS = -Iinclude

OBJS = test-a.o test-b.o test-c.o
PROG = test

all: $(PROG)

clean:
	rm -f $(OBJS) $(PROG)

test-hot-cache: $(PROG)

test-learning-cache: INCDIRS = -isystem include
test-learning-cache: $(PROG)

test-relative-cache: CC = ../bin/hcache gcc
test-relative-cache: $(PROG)

$(PROG): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $?

%.o: %.c
	$(CC) $(CFLAGS) $(INCDIRS) -c -o $@ $<

.PHONY: all clean test-hot-cache test-learning-cache test-relative-cache

