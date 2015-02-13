#include <stdlib.h>
#include <stdio.h>

void foo();

void bar() {
    printf("Bar called\n");
    foo();
}
