CC = ../bin/hcache --relative gcc
LD = gcc

INCDIRS = -Iinclude
LIBDIRS =

LIBS =

LIBDIR = lib
LIBOBJS = test-lib.o
LIB = $(LIBDIR)/libtest.a

OBJS = test-a.o test-b.o test-c.o
PROG = test

all: $(LIB) $(PROG)

clean:
	rm -rf $(LIBDIR) $(LIBOBJS) $(OBJS) $(PROG)

test-hot-cache: $(PROG)

test-learning-cache: INCDIRS = -isystem include
test-learning-cache: $(PROG)

test-relative-cache: CC = ../bin/hcache gcc
test-relative-cache: $(PROG)

test-configuration: $(PROG)

test-library: LIBDIRS = -Llib
test-library: LIBS = -ltest
test-library: $(LIB) $(PROG)

$(LIB): $(LIBOBJS)
	mkdir -p $(LIBDIR)
	$(AR) rc $@ $?

$(PROG): $(OBJS)
	$(LD) $(LDFLAGS) $(LIBDIRS) $(LIBS) -o $@ $?

%.o: %.c
	$(CC) $(CFLAGS) $(INCDIRS) -c -o $@ $<

.PHONY: all clean test-hot-cache test-learning-cache test-relative-cache
.PHONY: test-configuration test-library

