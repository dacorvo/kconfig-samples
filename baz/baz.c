#include <stdlib.h>
#include <stdio.h>

void bar();

void baz() {
    printf("Baz called\n");
    bar();
}
