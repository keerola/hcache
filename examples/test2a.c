#include <stdio.h>

#include "test2.h"

void
hello(void)
{
    printf("%s", HELLO);
}

int
main(void)
{
    hello();
    world();
   
    return 0;
}

