CC = ../bin/hcache gcc
LD = gcc

INCDIRS = -Iinclude

OBJS2 = test2a.o test2b.o test2c.o
PROG2 = test2

all: $(PROG2)

clean:
	rm -f $(OBJS1) $(PROG1) $(OBJS2) $(PROG2)

test3: INCDIRS = -isystem include
test3: $(PROG2)

$(PROG1): $(OBJS1)
	$(LD) $(LDFLAGS) -o $(PROG1) $(OBJS1)

$(PROG2): $(OBJS2)
	$(LD) $(LDFLAGS) -o $(PROG2) $(OBJS2)

%.o: %.c
	$(CC) $(CFLAGS) $(INCDIRS) -c -o $@ $<

.PHONY: all clean test3

