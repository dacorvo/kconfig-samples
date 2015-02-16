#include <stdlib.h>
#include <stdio.h>

#include "foo/foo.h"

void bar() {
    printf("Bar called\n");
    foo();
}
